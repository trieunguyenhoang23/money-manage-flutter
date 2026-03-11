// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values, avoid_escaping_inner_quotes

class S {
  S();

  static S? _current;

  static S get current {
    assert(
      _current != null,
      'No instance of S was loaded. Try to initialize the S delegate before accessing S.current.',
    );
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false)
        ? locale.languageCode
        : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = S();
      S._current = instance;

      return instance;
    });
  }

  static S of(BuildContext context) {
    final instance = S.maybeOf(context);
    assert(
      instance != null,
      'No instance of S present in the widget tree. Did you add S.delegate in localizationsDelegates?',
    );
    return instance!;
  }

  static S? maybeOf(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `Name`
  String get name {
    return Intl.message('Name', name: 'name', desc: '', args: []);
  }

  /// `Description`
  String get description {
    return Intl.message('Description', name: 'description', desc: '', args: []);
  }

  /// `Create`
  String get create {
    return Intl.message('Create', name: 'create', desc: '', args: []);
  }

  /// `Retry`
  String get retry {
    return Intl.message('Retry', name: 'retry', desc: '', args: []);
  }

  /// `Create at:`
  String get created_at {
    return Intl.message('Create at:', name: 'created_at', desc: '', args: []);
  }

  /// `Recent update:`
  String get updated_at {
    return Intl.message(
      'Recent update:',
      name: 'updated_at',
      desc: '',
      args: [],
    );
  }

  /// `Income`
  String get income {
    return Intl.message('Income', name: 'income', desc: '', args: []);
  }

  /// `Expense`
  String get expense {
    return Intl.message('Expense', name: 'expense', desc: '', args: []);
  }

  // skipped getter for the '//TRANSACTIONS' key

  /// `Transaction`
  String get transaction {
    return Intl.message('Transaction', name: 'transaction', desc: '', args: []);
  }

  /// `Income`
  String get transactions_income {
    return Intl.message(
      'Income',
      name: 'transactions_income',
      desc: '',
      args: [],
    );
  }

  /// `Expense`
  String get transactions_expense {
    return Intl.message(
      'Expense',
      name: 'transactions_expense',
      desc: '',
      args: [],
    );
  }

  // skipped getter for the '//ANALYTICS' key

  /// `Analysis`
  String get analytics {
    return Intl.message('Analysis', name: 'analytics', desc: '', args: []);
  }

  // skipped getter for the '//PROFILE' key

  /// `Profile`
  String get profile {
    return Intl.message('Profile', name: 'profile', desc: '', args: []);
  }

  /// `Login`
  String get profile_login {
    return Intl.message('Login', name: 'profile_login', desc: '', args: []);
  }

  /// `Logout`
  String get profile_logout {
    return Intl.message('Logout', name: 'profile_logout', desc: '', args: []);
  }

  // skipped getter for the '//CATEGORY' key

  /// `Category`
  String get category {
    return Intl.message('Category', name: 'category', desc: '', args: []);
  }

  /// `New category`
  String get category_create_new {
    return Intl.message(
      'New category',
      name: 'category_create_new',
      desc: '',
      args: [],
    );
  }

  /// `Name must be at least 3 characters`
  String get category_error_name_short {
    return Intl.message(
      'Name must be at least 3 characters',
      name: 'category_error_name_short',
      desc: '',
      args: [],
    );
  }

  /// `Description cannot be empty`
  String get category_error_desc_empty {
    return Intl.message(
      'Description cannot be empty',
      name: 'category_error_desc_empty',
      desc: '',
      args: [],
    );
  }

  /// `Something went wrong on our end`
  String get category_error_server {
    return Intl.message(
      'Something went wrong on our end',
      name: 'category_error_server',
      desc: '',
      args: [],
    );
  }

  /// `Edit Category`
  String get category_edit {
    return Intl.message(
      'Edit Category',
      name: 'category_edit',
      desc: '',
      args: [],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[Locale.fromSubtags(languageCode: 'en')];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
}
