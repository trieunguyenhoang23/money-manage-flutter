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

  /// `Update`
  String get update {
    return Intl.message('Update', name: 'update', desc: '', args: []);
  }

  /// `Retry`
  String get retry {
    return Intl.message('Retry', name: 'retry', desc: '', args: []);
  }

  /// `Note`
  String get note {
    return Intl.message('Note', name: 'note', desc: '', args: []);
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

  /// `Transaction At:`
  String get transaction_at {
    return Intl.message(
      'Transaction At:',
      name: 'transaction_at',
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

  /// `Balance`
  String get balance {
    return Intl.message('Balance', name: 'balance', desc: '', args: []);
  }

  /// `Image`
  String get image {
    return Intl.message('Image', name: 'image', desc: '', args: []);
  }

  /// `Gallery`
  String get gallery {
    return Intl.message('Gallery', name: 'gallery', desc: '', args: []);
  }

  /// `File`
  String get file {
    return Intl.message('File', name: 'file', desc: '', args: []);
  }

  /// `Cancel`
  String get cancel {
    return Intl.message('Cancel', name: 'cancel', desc: '', args: []);
  }

  /// `Confirm`
  String get confirm {
    return Intl.message('Confirm', name: 'confirm', desc: '', args: []);
  }

  /// `Synchronization error {keyword}`
  String sync_error(Object keyword) {
    return Intl.message(
      'Synchronization error $keyword',
      name: 'sync_error',
      desc: '',
      args: [keyword],
    );
  }

  /// `Synchronizing`
  String get sync_loading {
    return Intl.message(
      'Synchronizing',
      name: 'sync_loading',
      desc: '',
      args: [],
    );
  }

  /// `Complete synchronization`
  String get sync_complete {
    return Intl.message(
      'Complete synchronization',
      name: 'sync_complete',
      desc: '',
      args: [],
    );
  }

  /// `Language`
  String get language {
    return Intl.message('Language', name: 'language', desc: '', args: []);
  }

  /// `No data available`
  String get no_data {
    return Intl.message(
      'No data available',
      name: 'no_data',
      desc: '',
      args: [],
    );
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

  /// `New Transaction`
  String get transaction_create_new {
    return Intl.message(
      'New Transaction',
      name: 'transaction_create_new',
      desc: '',
      args: [],
    );
  }

  /// `Update Transaction`
  String get transaction_update {
    return Intl.message(
      'Update Transaction',
      name: 'transaction_update',
      desc: '',
      args: [],
    );
  }

  /// `Please enter an amount`
  String get transaction_validator_empty_amount {
    return Intl.message(
      'Please enter an amount',
      name: 'transaction_validator_empty_amount',
      desc: '',
      args: [],
    );
  }

  /// `Please choose one category`
  String get transaction_validator_empty_category {
    return Intl.message(
      'Please choose one category',
      name: 'transaction_validator_empty_category',
      desc: '',
      args: [],
    );
  }

  /// `No changes detected.`
  String get transaction_validator_no_change {
    return Intl.message(
      'No changes detected.',
      name: 'transaction_validator_no_change',
      desc: '',
      args: [],
    );
  }

  /// `Delete this transaction?`
  String get transaction_delete_item_title {
    return Intl.message(
      'Delete this transaction?',
      name: 'transaction_delete_item_title',
      desc: '',
      args: [],
    );
  }

  /// `Once deleted, you won't be able to recover this record`
  String get transaction_delete_item_content {
    return Intl.message(
      'Once deleted, you won\'t be able to recover this record',
      name: 'transaction_delete_item_content',
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

  /// `Currency`
  String get profile_currency {
    return Intl.message(
      'Currency',
      name: 'profile_currency',
      desc: '',
      args: [],
    );
  }

  /// `Theme`
  String get profile_theme {
    return Intl.message('Theme', name: 'profile_theme', desc: '', args: []);
  }

  /// `Remind`
  String get profile_remind {
    return Intl.message('Remind', name: 'profile_remind', desc: '', args: []);
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

  // skipped getter for the '//ANALYTIC' key

  /// `Analytic Overview`
  String get analytic_overview {
    return Intl.message(
      'Analytic Overview',
      name: 'analytic_overview',
      desc: '',
      args: [],
    );
  }

  /// `Analytic Category`
  String get analytic_category {
    return Intl.message(
      'Analytic Category',
      name: 'analytic_category',
      desc: '',
      args: [],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
      Locale.fromSubtags(languageCode: 'vi'),
    ];
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
