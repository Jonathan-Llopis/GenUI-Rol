import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ca.dart';
import 'app_localizations_en.dart';
import 'app_localizations_es.dart';
import 'app_localizations_fr.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ca'),
    Locale('en'),
    Locale('es'),
    Locale('fr')
  ];

  /// Accept button
  ///
  /// In en, this message translates to:
  /// **'Accept'**
  String get accept;

  /// Cancel button
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// Text for edit shop
  ///
  /// In en, this message translates to:
  /// **'Edit Shop'**
  String get edit_shop;

  /// Label for shop name
  ///
  /// In en, this message translates to:
  /// **'Shop {shopName}'**
  String shop_name(String shopName);

  /// Label for shop address
  ///
  /// In en, this message translates to:
  /// **'Shop Address'**
  String get shop_direction;

  /// Button for deleting shop
  ///
  /// In en, this message translates to:
  /// **'Delete Shop'**
  String get shop_delete;

  /// Add a profile image
  ///
  /// In en, this message translates to:
  /// **'Add a profile image'**
  String get add_profile_image;

  /// Label for camera option
  ///
  /// In en, this message translates to:
  /// **'Camera'**
  String get camera;

  /// Label for gallery option
  ///
  /// In en, this message translates to:
  /// **'Gallery'**
  String get gallery;

  /// Prompt to login to continue
  ///
  /// In en, this message translates to:
  /// **'Login to continue'**
  String get login_to_continue;

  /// Label for email input
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

  /// Label for password input
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// Prompt to enter the password
  ///
  /// In en, this message translates to:
  /// **'Please enter your password'**
  String get please_enter_your_password;

  /// Prompt for forgotten password
  ///
  /// In en, this message translates to:
  /// **'You forgot your password?'**
  String get you_forgot_your_password;

  /// Prompt to register if the user doesn't have an account
  ///
  /// In en, this message translates to:
  /// **'Don\'t have an account? Register here'**
  String get dont_have_an_account_register_here;

  /// Prompt to sign in to continue
  ///
  /// In en, this message translates to:
  /// **'Sign in to continue'**
  String get sign_in_to_continue;

  /// Label for username input
  ///
  /// In en, this message translates to:
  /// **'Username'**
  String get username;

  /// Label for name input
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get name;

  /// Label for confirmation password input
  ///
  /// In en, this message translates to:
  /// **'Confirmation Password'**
  String get confirmation_password;

  /// Label for table number
  ///
  /// In en, this message translates to:
  /// **'Table: {tableNumber}'**
  String table_number(int tableNumber);

  /// Label for error message
  ///
  /// In en, this message translates to:
  /// **'Error'**
  String get error;

  /// Label for available reservations
  ///
  /// In en, this message translates to:
  /// **'Available Reservations'**
  String get available_reservations;

  /// Label for filtering by date
  ///
  /// In en, this message translates to:
  /// **'Filter by date'**
  String get filter_by_date;

  /// Label for available reservations for a specific date
  ///
  /// In en, this message translates to:
  /// **'Available Reservations for: {date}'**
  String available_reservations_for_date(String date);

  /// Label for shop reviews
  ///
  /// In en, this message translates to:
  /// **'Shop Reviews'**
  String get shop_reviews;

  /// Label for rating input
  ///
  /// In en, this message translates to:
  /// **'Rating'**
  String get rating;

  /// Label for all reviews
  ///
  /// In en, this message translates to:
  /// **'All Reviews'**
  String get all_reviews;

  /// Label for available tables
  ///
  /// In en, this message translates to:
  /// **'Available Tables:'**
  String get available_tables;

  /// Label for save button
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// Label for Google login button
  ///
  /// In en, this message translates to:
  /// **'Google Login'**
  String get google_login;

  /// Label for login button
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get login;

  /// Error message indicating that the email or username already exists
  ///
  /// In en, this message translates to:
  /// **'The email or username already exists in the database'**
  String get email_or_username_exists;

  /// Label for register button
  ///
  /// In en, this message translates to:
  /// **'Register'**
  String get register;

  /// Label for update button
  ///
  /// In en, this message translates to:
  /// **'Update'**
  String get update;

  /// Label for reserve day
  ///
  /// In en, this message translates to:
  /// **'Reserve day: {dayDate}'**
  String reserve_day(String dayDate);

  /// Label for game description
  ///
  /// In en, this message translates to:
  /// **'Game: {gameDescription}'**
  String game_description(String gameDescription);

  /// Label for total players at table
  ///
  /// In en, this message translates to:
  /// **'Total players at table: {currentPlayers} of {totalPlaces}'**
  String total_players_at_table(int currentPlayers, int totalPlaces);

  /// Label for start time
  ///
  /// In en, this message translates to:
  /// **'Start time:'**
  String get start_time;

  /// Label for end time
  ///
  /// In en, this message translates to:
  /// **'End time: '**
  String get end_time;

  /// Label for anonymous user
  ///
  /// In en, this message translates to:
  /// **'Anonymous'**
  String get anonymous;

  /// Label for total seats at table
  ///
  /// In en, this message translates to:
  /// **'Total Seats at Table'**
  String get total_seats_at_table;

  /// Label for start time with format HH:MM
  ///
  /// In en, this message translates to:
  /// **'Start time (HH:MM)'**
  String get start_time_hh_mm;

  /// Label for end time with format HH:MM
  ///
  /// In en, this message translates to:
  /// **'End time (HH:MM)'**
  String get end_time_hh_mm;

  /// Label for description input
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get description;

  /// Label for required material input
  ///
  /// In en, this message translates to:
  /// **'Required Material'**
  String get required_material;

  /// Label for difficulty selection
  ///
  /// In en, this message translates to:
  /// **'Difficulty'**
  String get difficulty;

  /// Label for game category selection
  ///
  /// In en, this message translates to:
  /// **'Game Category'**
  String get game_category;

  /// Label for game selection
  ///
  /// In en, this message translates to:
  /// **'Game'**
  String get game;

  /// Label for add review button
  ///
  /// In en, this message translates to:
  /// **'Add Review'**
  String get add_review;

  /// Prompt to write a description
  ///
  /// In en, this message translates to:
  /// **'Please write a description'**
  String get please_write_a_description;

  /// Label for creating a new table
  ///
  /// In en, this message translates to:
  /// **'Create New Table'**
  String get create_new_table;

  /// Label for editing a table
  ///
  /// In en, this message translates to:
  /// **'Edit Table'**
  String get edit_table;

  /// Label for table number input
  ///
  /// In en, this message translates to:
  /// **'Table Number'**
  String get table_number_text;

  /// Label for deleting a table
  ///
  /// In en, this message translates to:
  /// **'Delete Table'**
  String get delete_table;

  /// Label for managing reservations
  ///
  /// In en, this message translates to:
  /// **'Manage Reservations'**
  String get manage_reservations;

  /// Confirmation message for deleting a shop
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete the shop?'**
  String get confirm_delete_shop;

  /// Message indicating that an email has been sent to reset the password
  ///
  /// In en, this message translates to:
  /// **'An email has been sent to your email to reset your password'**
  String get email_sent_reset_password;

  /// Label for user logout
  ///
  /// In en, this message translates to:
  /// **'User Logout'**
  String get user_logout;

  /// Confirmation message for logging out of the application
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to log out of the application?'**
  String get confirm_logout;

  /// Label for reset password
  ///
  /// In en, this message translates to:
  /// **'Reset Password'**
  String get reset_password;

  /// Prompt to enter email to reset password
  ///
  /// In en, this message translates to:
  /// **'Enter your email to reset your password'**
  String get enter_your_email_to_reset_password;

  /// Label for change password
  ///
  /// In en, this message translates to:
  /// **'Change Password'**
  String get change_password;

  /// Label for current password input
  ///
  /// In en, this message translates to:
  /// **'Current Password'**
  String get current_password;

  /// Label for new password input
  ///
  /// In en, this message translates to:
  /// **'New Password'**
  String get new_password;

  /// Label for user settings
  ///
  /// In en, this message translates to:
  /// **'User Settings'**
  String get user_settings;

  /// Confirmation message for deleting a table
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete the table?'**
  String get confirm_delete_table;

  /// Label for active game
  ///
  /// In en, this message translates to:
  /// **'Active game: {gameId}'**
  String active_game(String gameId);

  /// Label for schedule
  ///
  /// In en, this message translates to:
  /// **'Schedule:'**
  String get schedule;

  /// Label for day schedule
  ///
  /// In en, this message translates to:
  /// **'Day: {dayDate}  {startTime} - {endTime}'**
  String day_schedule(String dayDate, String startTime, String endTime);

  /// Label for free places
  ///
  /// In en, this message translates to:
  /// **'{freePlaces} free places'**
  String free_places(int freePlaces);

  /// Label for additional information
  ///
  /// In en, this message translates to:
  /// **'Additional Information:'**
  String get additional_information;

  /// Label for exit button
  ///
  /// In en, this message translates to:
  /// **'Exit'**
  String get exit;

  /// Label for join button
  ///
  /// In en, this message translates to:
  /// **'Join'**
  String get join;

  /// Label for edit tables button
  ///
  /// In en, this message translates to:
  /// **'Edit Tables'**
  String get edit_tables;

  /// Label for total tables
  ///
  /// In en, this message translates to:
  /// **'Total Tables: {totalTables}'**
  String total_tables(int totalTables);

  /// Label for reservations count
  ///
  /// In en, this message translates to:
  /// **'Reservations: {reservationsCount}'**
  String reservations(int reservationsCount);

  /// Welcome message for the user
  ///
  /// In en, this message translates to:
  /// **'Welcome {username}!'**
  String welcome_user(String username);

  /// Message indicating all available shops
  ///
  /// In en, this message translates to:
  /// **'These are all the available shops.'**
  String get all_available_shops;

  /// Label for shops registered in the user's name
  ///
  /// In en, this message translates to:
  /// **'Shops registered in your name:'**
  String get shops_registered_in_your_name;

  /// Message indicating the user has no shops
  ///
  /// In en, this message translates to:
  /// **'You have no shops'**
  String get no_shops;

  /// Label for remove filters button
  ///
  /// In en, this message translates to:
  /// **'Remove Filters'**
  String get remove_filters;

  /// Label for filter button
  ///
  /// In en, this message translates to:
  /// **'Filter'**
  String get filter;

  /// Label for filter free tables button
  ///
  /// In en, this message translates to:
  /// **'Filter Free Tables'**
  String get filter_free_tables;

  /// Label for finding your game table
  ///
  /// In en, this message translates to:
  /// **'Find your game table'**
  String get find_your_game_table;

  /// Label for home
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get home;

  /// Label for settings
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// Label for help
  ///
  /// In en, this message translates to:
  /// **'Help'**
  String get help;

  /// Label for logout
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get logout;

  /// Label for shop name
  ///
  /// In en, this message translates to:
  /// **'Shop Name'**
  String get shop_name_text;

  /// Label for shop location
  ///
  /// In en, this message translates to:
  /// **'Shop Location'**
  String get shop_location;

  /// Error message for loading reservations
  ///
  /// In en, this message translates to:
  /// **'Error loading reservations'**
  String get error_loading_reservations;

  /// Label for date
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get date;

  /// Error message indicating start time must be less than end time
  ///
  /// In en, this message translates to:
  /// **'Start time must be less than end time'**
  String get start_time_must_be_less_than_end_time;

  /// Error message indicating end time must be greater than start time
  ///
  /// In en, this message translates to:
  /// **'End time must be greater than start time'**
  String get end_time_must_be_greater_than_start_time;

  /// Error message indicating the time is already taken that day
  ///
  /// In en, this message translates to:
  /// **'The time is already taken that day'**
  String get time_already_taken_that_day;

  /// Error message indicating a required field
  ///
  /// In en, this message translates to:
  /// **'Required field'**
  String get required_field;

  /// Error message indicating the field must be a number
  ///
  /// In en, this message translates to:
  /// **'Must be a number'**
  String get must_be_a_number;

  /// Error message indicating the format must be HH:MM
  ///
  /// In en, this message translates to:
  /// **'The format must be HH:MM'**
  String get format_must_be_hh_mm;

  /// Error message indicating the name is already in use
  ///
  /// In en, this message translates to:
  /// **'The name is already in use.'**
  String get name_already_in_use;

  /// Error message indicating the email is already in use
  ///
  /// In en, this message translates to:
  /// **'The email is already in use.'**
  String get email_already_in_use;

  /// Error message indicating the password must be at least 8 characters long
  ///
  /// In en, this message translates to:
  /// **'The password must be at least 8 characters long'**
  String get password_must_be_at_least_8_characters;

  /// Error message indicating the password must contain at least one number
  ///
  /// In en, this message translates to:
  /// **'The password must contain at least one number'**
  String get password_must_contain_at_least_one_number;

  /// Error message indicating the password must contain at least one uppercase letter
  ///
  /// In en, this message translates to:
  /// **'The password must contain at least one uppercase letter'**
  String get password_must_contain_at_least_one_uppercase_letter;

  /// Error message indicating the password must contain at least one lowercase letter
  ///
  /// In en, this message translates to:
  /// **'The password must contain at least one lowercase letter'**
  String get password_must_contain_at_least_one_lowercase_letter;

  /// Error message indicating the passwords do not match
  ///
  /// In en, this message translates to:
  /// **'The passwords do not match'**
  String get passwords_do_not_match;

  /// Error message indicating the password is incorrect
  ///
  /// In en, this message translates to:
  /// **'The password is incorrect'**
  String get password_is_incorrect;

  /// Error message indicating an error occurred while validating the password
  ///
  /// In en, this message translates to:
  /// **'Error validating the password'**
  String get error_validating_password;

  /// Error message indicating the table number already exists
  ///
  /// In en, this message translates to:
  /// **'The table number already exists'**
  String get table_number_already_exists;

  /// Label for players
  ///
  /// In en, this message translates to:
  /// **'Players'**
  String get players;

  /// Error message indicating the field must be an email
  ///
  /// In en, this message translates to:
  /// **'Email Invalid'**
  String get email_invalid;

  /// Text for chaning language
  ///
  /// In en, this message translates to:
  /// **'Change Language'**
  String get changeLanguage;

  /// Label for going to events
  ///
  /// In en, this message translates to:
  /// **'Go to Events'**
  String get go_to_events;

  /// Label for events
  ///
  /// In en, this message translates to:
  /// **'Events'**
  String get events;

  /// Label for your reservations
  ///
  /// In en, this message translates to:
  /// **'Your Reservations'**
  String get your_reservations;

  /// Prompt to select the tables to occupy
  ///
  /// In en, this message translates to:
  /// **'Select the tables to occupy'**
  String get select_tables_to_occupy;

  /// Help text for selecting the start date of the event
  ///
  /// In en, this message translates to:
  /// **'Select the start date of the event'**
  String get select_start_date;

  /// Error message for start date not selected
  ///
  /// In en, this message translates to:
  /// **'Start date not selected'**
  String get start_date_not_selected;

  /// Error message for start time not selected
  ///
  /// In en, this message translates to:
  /// **'Start time not selected'**
  String get start_time_not_selected;

  /// Help text for selecting the end date of the event
  ///
  /// In en, this message translates to:
  /// **'Select the end date of the event'**
  String get select_end_date;

  /// Error message for end date not selected
  ///
  /// In en, this message translates to:
  /// **'End date not selected'**
  String get end_date_not_selected;

  /// Error message for end date before start date
  ///
  /// In en, this message translates to:
  /// **'End date cannot be before start date'**
  String get end_date_before_start_date;

  /// Error message for event must be on the same day
  ///
  /// In en, this message translates to:
  /// **'The event must be on the same day'**
  String get event_same_day;

  /// Error message for end time not selected
  ///
  /// In en, this message translates to:
  /// **'End time not selected'**
  String get end_time_not_selected;

  /// Message indicating the game session has not started
  ///
  /// In en, this message translates to:
  /// **'The game session has not started yet'**
  String get game_session_not_started;

  /// Error message indicating the reservation table is wrong
  ///
  /// In en, this message translates to:
  /// **'Wrong reservation table'**
  String get wrong_reservation_table;

  /// Label for scan again button
  ///
  /// In en, this message translates to:
  /// **'Scan Again'**
  String get scan_again;

  /// Label for granting camera permission
  ///
  /// In en, this message translates to:
  /// **'Grant camera permission'**
  String get grant_camera_permission;

  /// Message indicating that the location service is disabled
  ///
  /// In en, this message translates to:
  /// **'Location service is disabled.'**
  String get location_service_disabled;

  /// Message indicating that the location permissions are denied
  ///
  /// In en, this message translates to:
  /// **'Location permissions are denied.'**
  String get location_permission_denied;

  /// Message indicating that the location permissions are permanently denied
  ///
  /// In en, this message translates to:
  /// **'Location permissions are permanently denied.'**
  String get location_permission_denied_permanently;

  /// Message indicating that the reservation has been confirmed
  ///
  /// In en, this message translates to:
  /// **'Your reservation has been confirmed!'**
  String get reservation_confirmed;

  /// Message indicating the user is not in the shop location
  ///
  /// In en, this message translates to:
  /// **'You are not in the shop location'**
  String get not_in_shop_location;

  /// Label for game event
  ///
  /// In en, this message translates to:
  /// **'Game Event: {gameEvent}'**
  String game_event(String gameEvent);

  /// Label for event day date
  ///
  /// In en, this message translates to:
  /// **'Event: {dayDate}'**
  String event_day_date(String dayDate);

  /// Message indicating that the reservation has been confirmed in Spanish
  ///
  /// In en, this message translates to:
  /// **'Reservation Confirmed'**
  String get reserva_confirmada;

  /// Prompt to select your location on the map
  ///
  /// In en, this message translates to:
  /// **'Select your location on the map:'**
  String get select_your_location_on_map;

  /// Error message with snapshot error
  ///
  /// In en, this message translates to:
  /// **'Error: {snapshotError}'**
  String error_snapshot(String snapshotError);

  /// Label for store events
  ///
  /// In en, this message translates to:
  /// **'Store Events'**
  String get store_events;

  /// Label for confirm button
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get confirm;

  /// Label for English language
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get english;

  /// Label for Spanish language
  ///
  /// In en, this message translates to:
  /// **'Spanish'**
  String get spanish;

  /// Label for French language
  ///
  /// In en, this message translates to:
  /// **'French'**
  String get french;

  /// Label for Catalan language
  ///
  /// In en, this message translates to:
  /// **'Catalan'**
  String get catalan;

  /// Label for month
  ///
  /// In en, this message translates to:
  /// **'Month'**
  String get month;

  /// Label for quarter
  ///
  /// In en, this message translates to:
  /// **'Quarter'**
  String get quarter;

  /// Label for annual
  ///
  /// In en, this message translates to:
  /// **'Annual'**
  String get annual;

  /// Label for the total number of reservations
  ///
  /// In en, this message translates to:
  /// **'Total Reserves'**
  String get total_reservations;

  /// Label for the number of active players
  ///
  /// In en, this message translates to:
  /// **'Active Players'**
  String get active_players;

  /// Label for the busiest hours
  ///
  /// In en, this message translates to:
  /// **'Peak Hours'**
  String get peak_hours;

  /// Label for popular games
  ///
  /// In en, this message translates to:
  /// **'Popular Games'**
  String get popular_games;

  /// Label for total reservations by selected period
  ///
  /// In en, this message translates to:
  /// **'Total Reservations for {selectedPeriod}'**
  String total_reservations_by_period(String selectedPeriod);

  /// Label for active players by selected period
  ///
  /// In en, this message translates to:
  /// **'Active Players for {selectedPeriod}'**
  String active_players_by_period(String selectedPeriod);

  /// Label for peak reservation hours
  ///
  /// In en, this message translates to:
  /// **'Peak Reservation Hours'**
  String get peak_reservation_hours;

  /// Label for most popular games
  ///
  /// In en, this message translates to:
  /// **'Most Popular Games'**
  String get most_popular_games;

  /// Label for games
  ///
  /// In en, this message translates to:
  /// **'Games'**
  String get games;

  /// Prompt to ask the AI about rules questions
  ///
  /// In en, this message translates to:
  /// **'Ask AI about rules'**
  String get ask_ai_about_rules;

  /// Label for sending a message
  ///
  /// In en, this message translates to:
  /// **'Send a message'**
  String get send_message;

  /// Message indicating that the chat is loading
  ///
  /// In en, this message translates to:
  /// **'Loading chat...'**
  String get loading_chat;

  /// Error message indicating that the user or password is incorrect
  ///
  /// In en, this message translates to:
  /// **'User or password incorrect'**
  String get user_or_password_incorrect;

  /// Label for nearby shops
  ///
  /// In en, this message translates to:
  /// **'Nearby Shops'**
  String get nearby_shops;

  /// Label for go to shop
  ///
  /// In en, this message translates to:
  /// **'Go to Shop'**
  String get go_to_shop;

  /// Label for confirmed status
  ///
  /// In en, this message translates to:
  /// **'Confirmed'**
  String get confirmed;

  /// Label for pending status
  ///
  /// In en, this message translates to:
  /// **'Pending'**
  String get pending;

  /// Message indicating that the content is loading
  ///
  /// In en, this message translates to:
  /// **'Loading...'**
  String get loading;

  /// Label for unsubscribed status
  ///
  /// In en, this message translates to:
  /// **'Unsubscribed'**
  String get unsubscribed;

  /// Label for subscribed status
  ///
  /// In en, this message translates to:
  /// **'Subscribed'**
  String get subscribed;

  /// Label for the latest players
  ///
  /// In en, this message translates to:
  /// **'Latest Players'**
  String get latest_players;

  /// Label for store statistics
  ///
  /// In en, this message translates to:
  /// **'Store Statistics'**
  String get store_statistics;

  /// Label for seats
  ///
  /// In en, this message translates to:
  /// **'Seats'**
  String get seats;

  /// No description provided for @store_map.
  ///
  /// In en, this message translates to:
  /// **'Stores Map'**
  String get store_map;

  /// Label for your reviews
  ///
  /// In en, this message translates to:
  /// **'Your Reviews'**
  String get your_reviews;

  /// Label for chat with AI
  ///
  /// In en, this message translates to:
  /// **'Chat with AI'**
  String get chat_with_ai;

  /// Label for processing code
  ///
  /// In en, this message translates to:
  /// **'Processing Code'**
  String get processing_code;

  /// Label for aligning QR code
  ///
  /// In en, this message translates to:
  /// **'Align QR Code'**
  String get align_qr_code;

  /// Error message for processing code
  ///
  /// In en, this message translates to:
  /// **'Error Processing Code'**
  String get error_processing_code;

  /// Label for editing info
  ///
  /// In en, this message translates to:
  /// **'Edit Info.'**
  String get edit_info;

  /// Label for received reviews
  ///
  /// In en, this message translates to:
  /// **'Received Reviews'**
  String get received_reviews;

  /// Label for players the user has played with
  ///
  /// In en, this message translates to:
  /// **'Played with'**
  String get played_with;

  /// Welcome message for Roll & Reserve
  ///
  /// In en, this message translates to:
  /// **'Welcome to Roll & Reserve, {name}!'**
  String welcome_to_roll_and_reserve(String name);

  /// Message encouraging users to find and reserve their game table
  ///
  /// In en, this message translates to:
  /// **'Find your ideal game table and reserve in seconds.'**
  String get find_your_ideal_game_table;

  /// Message encouraging users to discover nearby shops
  ///
  /// In en, this message translates to:
  /// **'Discover shops near you'**
  String get discover_nearby_shops;

  /// Message encouraging users to explore shops with tables and ratings
  ///
  /// In en, this message translates to:
  /// **'Explore shops with available tables and community ratings'**
  String get explore_shops_with_tables;

  /// Message indicating the simplicity of reserving a table
  ///
  /// In en, this message translates to:
  /// **'Reserve in a few steps'**
  String get reserve_in_few_steps;

  /// Message explaining the reservation process
  ///
  /// In en, this message translates to:
  /// **'Select date, time, and necessary materials for your game'**
  String get select_date_time_materials;

  /// Message encouraging users to manage their reservations and settings
  ///
  /// In en, this message translates to:
  /// **'Manage your experience'**
  String get manage_your_experience;

  /// Message explaining the features for managing reservations, reviews, and settings
  ///
  /// In en, this message translates to:
  /// **'Control your reservations, reviews, and settings from one place. Now you can even ask the AI your questions.'**
  String get control_reservations_reviews_settings;

  /// Label for skip button
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get skip;

  /// Label for get started button
  ///
  /// In en, this message translates to:
  /// **'Get Started'**
  String get get_started;

  /// Welcome message for store owners
  ///
  /// In en, this message translates to:
  /// **'Welcome {name}, Store Owner!'**
  String welcome_store_owner(String name);

  /// Message encouraging store owners to manage their game space
  ///
  /// In en, this message translates to:
  /// **'Manage your game space professionally and efficiently'**
  String get manage_your_game_space;

  /// Label for setting up the store
  ///
  /// In en, this message translates to:
  /// **'Set Up Your Store'**
  String get setup_your_store;

  /// Message prompting store owners to add location and details
  ///
  /// In en, this message translates to:
  /// **'Add location and details of your establishment'**
  String get add_location_and_details;

  /// Label for managing tables
  ///
  /// In en, this message translates to:
  /// **'Manage Tables'**
  String get manage_tables;

  /// Message explaining table management features
  ///
  /// In en, this message translates to:
  /// **'Create and edit available tables\nManage capacities and special features'**
  String get create_and_edit_tables;

  /// Label for scheduling events
  ///
  /// In en, this message translates to:
  /// **'Schedule Events'**
  String get schedule_events;

  /// Message encouraging store owners to organize events
  ///
  /// In en, this message translates to:
  /// **'Organize tournaments and special activities\nControl capacities and reservations'**
  String get organize_tournaments_and_activities;

  /// Label for analyzing and improving
  ///
  /// In en, this message translates to:
  /// **'Analyze and Improve'**
  String get analyze_and_improve;

  /// Message encouraging store owners to monitor and improve based on data
  ///
  /// In en, this message translates to:
  /// **'Monitor reservations, reviews, and statistics\nMake data-driven decisions'**
  String get monitor_reservations_reviews_statistics;

  /// Label for go to home button
  ///
  /// In en, this message translates to:
  /// **'Go to Home'**
  String get go_to_home;

  /// Label for admin role
  ///
  /// In en, this message translates to:
  /// **'Admin'**
  String get role_admin;

  /// Label for user role
  ///
  /// In en, this message translates to:
  /// **'User'**
  String get role_user;

  /// Label for owner role
  ///
  /// In en, this message translates to:
  /// **'Owner'**
  String get role_owner;

  /// Label for role selection
  ///
  /// In en, this message translates to:
  /// **'Role'**
  String get role;

  /// Error message indicating an issue with selecting a user
  ///
  /// In en, this message translates to:
  /// **'Error selecting user'**
  String get error_select_user;

  /// Label for selecting a user
  ///
  /// In en, this message translates to:
  /// **'Select User'**
  String get select_user;

  /// Message indicating all the users
  ///
  /// In en, this message translates to:
  /// **'These are all the users'**
  String get all_users;

  /// Message indicating all the shops
  ///
  /// In en, this message translates to:
  /// **'These are all the shops'**
  String get all_shops;

  /// Label for AI Assistant
  ///
  /// In en, this message translates to:
  /// **'AI Assistant'**
  String get ai_assistant;

  /// Label for the user
  ///
  /// In en, this message translates to:
  /// **'You'**
  String get you;

  /// Label for restarting the conversation
  ///
  /// In en, this message translates to:
  /// **'Restart Conversation'**
  String get restart_conversation;

  /// Message indicating that the app is locating the user
  ///
  /// In en, this message translates to:
  /// **'Locating you...'**
  String get locating_you;

  /// Label for retry button
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retry;

  /// Message prompting the user to tap on a marker for more information
  ///
  /// In en, this message translates to:
  /// **'Tap on a marker for more information'**
  String get tap_marker_info;

  /// Label for playing a role-playing game with AI
  ///
  /// In en, this message translates to:
  /// **'Play Role with AI'**
  String get play_role_with_ai;

  /// Prompt to choose the world for the user's adventure
  ///
  /// In en, this message translates to:
  /// **'Choose the world where you want to live your adventure'**
  String get choose_world_adventure;

  /// Label for describing your adventure
  ///
  /// In en, this message translates to:
  /// **'Describe Your Adventure'**
  String get describe_your_adventure;

  /// Prompt to enter the adventurers description
  ///
  /// In en, this message translates to:
  /// **'Enter Adventurers Description'**
  String get enter_adventurers_description;

  /// Label for adventurers description
  ///
  /// In en, this message translates to:
  /// **'Adventurers Description'**
  String get adventurers_description;

  /// Label for starting the game
  ///
  /// In en, this message translates to:
  /// **'Start Game'**
  String get start_game;

  /// Confirmation message for deleting an adventure
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this adventure? This action cannot be undone.'**
  String get confirm_delete_adventure;

  /// Label for deleting an adventure
  ///
  /// In en, this message translates to:
  /// **'Delete Adventure'**
  String get delete_adventure;

  /// Error message indicating that the character data is incomplete or null
  ///
  /// In en, this message translates to:
  /// **'Error: Character data incomplete or null.'**
  String get error_character_data_incomplete_or_null;

  /// Label for primary attributes section
  ///
  /// In en, this message translates to:
  /// **'Primary Attributes'**
  String get primary_attributes;

  /// Label for health and defense section
  ///
  /// In en, this message translates to:
  /// **'Health and Defense'**
  String get health_and_defense;

  /// Label for magical skills section
  ///
  /// In en, this message translates to:
  /// **'Magical Skills'**
  String get magical_skills;

  /// Label for equipment and treasure section
  ///
  /// In en, this message translates to:
  /// **'Equipment and Treasure'**
  String get equipment_and_treasure;

  /// Label for companion section
  ///
  /// In en, this message translates to:
  /// **'Companion'**
  String get companion;

  /// Label for strength attribute
  ///
  /// In en, this message translates to:
  /// **'Strength'**
  String get strength;

  /// Label for dexterity attribute
  ///
  /// In en, this message translates to:
  /// **'Dexterity'**
  String get dexterity;

  /// Label for constitution attribute
  ///
  /// In en, this message translates to:
  /// **'Constitution'**
  String get constitution;

  /// Label for intelligence attribute
  ///
  /// In en, this message translates to:
  /// **'Intelligence'**
  String get intelligence;

  /// Label for wisdom attribute
  ///
  /// In en, this message translates to:
  /// **'Wisdom'**
  String get wisdom;

  /// Label for charisma attribute
  ///
  /// In en, this message translates to:
  /// **'Charisma'**
  String get charisma;

  /// Label for character level
  ///
  /// In en, this message translates to:
  /// **'Level'**
  String get level;

  /// Label for known spells section
  ///
  /// In en, this message translates to:
  /// **'Known Spells'**
  String get known_spells;

  /// Label for cantrips section
  ///
  /// In en, this message translates to:
  /// **'Cantrips'**
  String get cantrips;

  /// Label for level 1 spell slots
  ///
  /// In en, this message translates to:
  /// **'Level 1 Spell Slots:'**
  String get level_1_spell_slots;

  /// Prompt asking the user to describe the setting of their adventure
  ///
  /// In en, this message translates to:
  /// **'Describe the setting of your adventure'**
  String get setting_description;

  /// Label for asking questions about the rules
  ///
  /// In en, this message translates to:
  /// **'Ask your questions about the rules'**
  String get ask_about_rules;

  /// Label for identifying board games
  ///
  /// In en, this message translates to:
  /// **'Identify board games'**
  String get identify_board_games;

  /// Label for profile settings
  ///
  /// In en, this message translates to:
  /// **'Profile Settings'**
  String get profile_settings;

  /// Label for user management
  ///
  /// In en, this message translates to:
  /// **'User Management'**
  String get user_management;

  /// Label for chat features
  ///
  /// In en, this message translates to:
  /// **'Chat Features'**
  String get chat_features;

  /// Label for narrator
  ///
  /// In en, this message translates to:
  /// **'Narrator'**
  String get narrator;

  /// Label for Game Vision AI
  ///
  /// In en, this message translates to:
  /// **'Game Vision AI'**
  String get game_vision_ai;

  /// Prompt asking the user to describe their move
  ///
  /// In en, this message translates to:
  /// **'Describe your move'**
  String get describe_your_move;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['ca', 'en', 'es', 'fr'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ca':
      return AppLocalizationsCa();
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
    case 'fr':
      return AppLocalizationsFr();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
