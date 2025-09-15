// lib/providers/auth_provider.dart
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthProvider extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  User? _currentUser;
  bool _isLoading = false;
  String? _errorMessage;
  Map<String, dynamic>? _userProfile;

  // Getters
  User? get currentUser => _currentUser;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  Map<String, dynamic>? get userProfile => _userProfile;
  bool get isAuthenticated => _currentUser != null;

  // Constructor
  AuthProvider() {
    _auth.authStateChanges().listen((User? user) {
      _currentUser = user;
      if (user != null) {
        _loadUserProfile();
      } else {
        _userProfile = null;
      }
      notifyListeners();
    });
  }

  // Sign up method
  Future<void> signup({
    required String email,
    required String password,
    required String fullName,
    required String phone,
  }) async {
    try {
      _setLoading(true);
      _clearError();

      // Create user with Firebase Auth
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Update display name
      await userCredential.user?.updateDisplayName(fullName);

      // Create user profile in Firestore
      await _firestore.collection('users').doc(userCredential.user!.uid).set({
        'email': email,
        'profile': {
          'name': fullName,
          'phone': phone,
        },
        'createdAt': FieldValue.serverTimestamp(),
        'isVerified': false,
        'role': null, // Will be set in user type selection
      });

    } catch (e) {
      _setError(e.toString());
      rethrow;
    } finally {
      _setLoading(false);
    }
  }

  // Login method
  Future<void> login(String email, String password) async {
    try {
      _setLoading(true);
      _clearError();

      await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

    } catch (e) {
      _setError(e.toString());
      rethrow;
    } finally {
      _setLoading(false);
    }
  }

  // Update user type
  Future<void> updateUserType(String userType) async {
    try {
      _setLoading(true);

      if (_currentUser != null) {
        await _firestore.collection('users').doc(_currentUser!.uid).update({
          'role': userType,
        });

        // Create role-specific document
        if (userType == 'donor') {
          await _firestore.collection('donors').doc(_currentUser!.uid).set({
            'availability': {
              'isAvailable': true,
              'emergencyOnly': false,
            },
            'donationStats': {
              'totalDonations': 0,
              'lastDonation': null,
            },
            'rewards': {
              'points': 0,
              'badges': [],
              'nftTokens': [],
            },
            'createdAt': FieldValue.serverTimestamp(),
          });
        } else if (userType == 'hospital') {
          await _firestore.collection('hospitals').doc(_currentUser!.uid).set({
            'verificationStatus': 'pending',
            'inventory': {},
            'createdAt': FieldValue.serverTimestamp(),
          });
        }

        await _loadUserProfile();
      }
    } catch (e) {
      _setError(e.toString());
      rethrow;
    } finally {
      _setLoading(false);
    }
  }

  // Load user profile
  Future<void> _loadUserProfile() async {
    if (_currentUser != null) {
      try {
        DocumentSnapshot userDoc = await _firestore
            .collection('users')
            .doc(_currentUser!.uid)
            .get();

        if (userDoc.exists) {
          _userProfile = userDoc.data() as Map<String, dynamic>?;
          notifyListeners();
        }
      } catch (e) {
        print('Error loading user profile: $e');
      }
    }
  }

  // Logout method
  Future<void> logout() async {
    await _auth.signOut();
    _userProfile = null;
    notifyListeners();
  }

  // Helper methods
  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setError(String error) {
    _errorMessage = error;
    notifyListeners();
  }

  void _clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
