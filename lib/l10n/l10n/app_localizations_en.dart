// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get accept => 'Accept';

  @override
  String get cancel => 'Cancel';

  @override
  String get edit_shop => 'Edit Shop';

  @override
  String shop_name(String shopName) {
    return 'Shop $shopName';
  }

  @override
  String get shop_direction => 'Shop Address';

  @override
  String get shop_delete => 'Delete Shop';

  @override
  String get add_profile_image => 'Add a profile image';

  @override
  String get camera => 'Camera';

  @override
  String get gallery => 'Gallery';

  @override
  String get login_to_continue => 'Login to continue';

  @override
  String get email => 'Email';

  @override
  String get password => 'Password';

  @override
  String get please_enter_your_password => 'Please enter your password';

  @override
  String get you_forgot_your_password => 'You forgot your password?';

  @override
  String get dont_have_an_account_register_here =>
      'Don\'t have an account? Register here';

  @override
  String get sign_in_to_continue => 'Sign in to continue';

  @override
  String get username => 'Username';

  @override
  String get name => 'Name';

  @override
  String get confirmation_password => 'Confirmation Password';

  @override
  String table_number(int tableNumber) {
    return 'Table: $tableNumber';
  }

  @override
  String get error => 'Error';

  @override
  String get available_reservations => 'Available Reservations';

  @override
  String get filter_by_date => 'Filter by date';

  @override
  String available_reservations_for_date(String date) {
    return 'Available Reservations for: $date';
  }

  @override
  String get shop_reviews => 'Shop Reviews';

  @override
  String get rating => 'Rating';

  @override
  String get all_reviews => 'All Reviews';

  @override
  String get available_tables => 'Available Tables:';

  @override
  String get save => 'Save';

  @override
  String get google_login => 'Google Login';

  @override
  String get login => 'Login';

  @override
  String get email_or_username_exists =>
      'The email or username already exists in the database';

  @override
  String get register => 'Register';

  @override
  String get update => 'Update';

  @override
  String reserve_day(String dayDate) {
    return 'Reserve day: $dayDate';
  }

  @override
  String game_description(String gameDescription) {
    return 'Game: $gameDescription';
  }

  @override
  String total_players_at_table(int currentPlayers, int totalPlaces) {
    return 'Total players at table: $currentPlayers of $totalPlaces';
  }

  @override
  String get start_time => 'Start time:';

  @override
  String get end_time => 'End time: ';

  @override
  String get anonymous => 'Anonymous';

  @override
  String get total_seats_at_table => 'Total Seats at Table';

  @override
  String get start_time_hh_mm => 'Start time (HH:MM)';

  @override
  String get end_time_hh_mm => 'End time (HH:MM)';

  @override
  String get description => 'Description';

  @override
  String get required_material => 'Required Material';

  @override
  String get difficulty => 'Difficulty';

  @override
  String get game_category => 'Game Category';

  @override
  String get game => 'Game';

  @override
  String get add_review => 'Add Review';

  @override
  String get please_write_a_description => 'Please write a description';

  @override
  String get create_new_table => 'Create New Table';

  @override
  String get edit_table => 'Edit Table';

  @override
  String get table_number_text => 'Table Number';

  @override
  String get delete_table => 'Delete Table';

  @override
  String get manage_reservations => 'Manage Reservations';

  @override
  String get confirm_delete_shop => 'Are you sure you want to delete the shop?';

  @override
  String get email_sent_reset_password =>
      'An email has been sent to your email to reset your password';

  @override
  String get user_logout => 'User Logout';

  @override
  String get confirm_logout =>
      'Are you sure you want to log out of the application?';

  @override
  String get reset_password => 'Reset Password';

  @override
  String get enter_your_email_to_reset_password =>
      'Enter your email to reset your password';

  @override
  String get change_password => 'Change Password';

  @override
  String get current_password => 'Current Password';

  @override
  String get new_password => 'New Password';

  @override
  String get user_settings => 'User Settings';

  @override
  String get confirm_delete_table =>
      'Are you sure you want to delete the table?';

  @override
  String active_game(String gameId) {
    return 'Active game: $gameId';
  }

  @override
  String get schedule => 'Schedule:';

  @override
  String day_schedule(String dayDate, String startTime, String endTime) {
    return 'Day: $dayDate  $startTime - $endTime';
  }

  @override
  String free_places(int freePlaces) {
    return '$freePlaces free places';
  }

  @override
  String get additional_information => 'Additional Information:';

  @override
  String get exit => 'Exit';

  @override
  String get join => 'Join';

  @override
  String get edit_tables => 'Edit Tables';

  @override
  String total_tables(int totalTables) {
    return 'Total Tables: $totalTables';
  }

  @override
  String reservations(int reservationsCount) {
    return 'Reservations: $reservationsCount';
  }

  @override
  String welcome_user(String username) {
    return 'Welcome $username!';
  }

  @override
  String get all_available_shops => 'These are all the available shops.';

  @override
  String get shops_registered_in_your_name => 'Shops registered in your name:';

  @override
  String get no_shops => 'You have no shops';

  @override
  String get remove_filters => 'Remove Filters';

  @override
  String get filter => 'Filter';

  @override
  String get filter_free_tables => 'Filter Free Tables';

  @override
  String get find_your_game_table => 'Find your game table';

  @override
  String get home => 'Home';

  @override
  String get settings => 'Settings';

  @override
  String get help => 'Help';

  @override
  String get logout => 'Logout';

  @override
  String get shop_name_text => 'Shop Name';

  @override
  String get shop_location => 'Shop Location';

  @override
  String get error_loading_reservations => 'Error loading reservations';

  @override
  String get date => 'Date';

  @override
  String get start_time_must_be_less_than_end_time =>
      'Start time must be less than end time';

  @override
  String get end_time_must_be_greater_than_start_time =>
      'End time must be greater than start time';

  @override
  String get time_already_taken_that_day =>
      'The time is already taken that day';

  @override
  String get required_field => 'Required field';

  @override
  String get must_be_a_number => 'Must be a number';

  @override
  String get format_must_be_hh_mm => 'The format must be HH:MM';

  @override
  String get name_already_in_use => 'The name is already in use.';

  @override
  String get email_already_in_use => 'The email is already in use.';

  @override
  String get password_must_be_at_least_8_characters =>
      'The password must be at least 8 characters long';

  @override
  String get password_must_contain_at_least_one_number =>
      'The password must contain at least one number';

  @override
  String get password_must_contain_at_least_one_uppercase_letter =>
      'The password must contain at least one uppercase letter';

  @override
  String get password_must_contain_at_least_one_lowercase_letter =>
      'The password must contain at least one lowercase letter';

  @override
  String get passwords_do_not_match => 'The passwords do not match';

  @override
  String get password_is_incorrect => 'The password is incorrect';

  @override
  String get error_validating_password => 'Error validating the password';

  @override
  String get table_number_already_exists => 'The table number already exists';

  @override
  String get players => 'Players';

  @override
  String get email_invalid => 'Email Invalid';

  @override
  String get changeLanguage => 'Change Language';

  @override
  String get go_to_events => 'Go to Events';

  @override
  String get events => 'Events';

  @override
  String get your_reservations => 'Your Reservations';

  @override
  String get select_tables_to_occupy => 'Select the tables to occupy';

  @override
  String get select_start_date => 'Select the start date of the event';

  @override
  String get start_date_not_selected => 'Start date not selected';

  @override
  String get start_time_not_selected => 'Start time not selected';

  @override
  String get select_end_date => 'Select the end date of the event';

  @override
  String get end_date_not_selected => 'End date not selected';

  @override
  String get end_date_before_start_date =>
      'End date cannot be before start date';

  @override
  String get event_same_day => 'The event must be on the same day';

  @override
  String get end_time_not_selected => 'End time not selected';

  @override
  String get game_session_not_started => 'The game session has not started yet';

  @override
  String get wrong_reservation_table => 'Wrong reservation table';

  @override
  String get scan_again => 'Scan Again';

  @override
  String get grant_camera_permission => 'Grant camera permission';

  @override
  String get location_service_disabled => 'Location service is disabled.';

  @override
  String get location_permission_denied => 'Location permissions are denied.';

  @override
  String get location_permission_denied_permanently =>
      'Location permissions are permanently denied.';

  @override
  String get reservation_confirmed => 'Your reservation has been confirmed!';

  @override
  String get not_in_shop_location => 'You are not in the shop location';

  @override
  String game_event(String gameEvent) {
    return 'Game Event: $gameEvent';
  }

  @override
  String event_day_date(String dayDate) {
    return 'Event: $dayDate';
  }

  @override
  String get reserva_confirmada => 'Reservation Confirmed';

  @override
  String get select_your_location_on_map => 'Select your location on the map:';

  @override
  String error_snapshot(String snapshotError) {
    return 'Error: $snapshotError';
  }

  @override
  String get store_events => 'Store Events';

  @override
  String get confirm => 'Confirm';

  @override
  String get english => 'English';

  @override
  String get spanish => 'Spanish';

  @override
  String get french => 'French';

  @override
  String get catalan => 'Catalan';

  @override
  String get month => 'Month';

  @override
  String get quarter => 'Quarter';

  @override
  String get annual => 'Annual';

  @override
  String get total_reservations => 'Total Reserves';

  @override
  String get active_players => 'Active Players';

  @override
  String get peak_hours => 'Peak Hours';

  @override
  String get popular_games => 'Popular Games';

  @override
  String total_reservations_by_period(String selectedPeriod) {
    return 'Total Reservations for $selectedPeriod';
  }

  @override
  String active_players_by_period(String selectedPeriod) {
    return 'Active Players for $selectedPeriod';
  }

  @override
  String get peak_reservation_hours => 'Peak Reservation Hours';

  @override
  String get most_popular_games => 'Most Popular Games';

  @override
  String get games => 'Games';

  @override
  String get ask_ai_about_rules => 'Ask AI about rules';

  @override
  String get send_message => 'Send a message';

  @override
  String get loading_chat => 'Loading chat...';

  @override
  String get user_or_password_incorrect => 'User or password incorrect';

  @override
  String get nearby_shops => 'Nearby Shops';

  @override
  String get go_to_shop => 'Go to Shop';

  @override
  String get confirmed => 'Confirmed';

  @override
  String get pending => 'Pending';

  @override
  String get loading => 'Loading...';

  @override
  String get unsubscribed => 'Unsubscribed';

  @override
  String get subscribed => 'Subscribed';

  @override
  String get latest_players => 'Latest Players';

  @override
  String get store_statistics => 'Store Statistics';

  @override
  String get seats => 'Seats';

  @override
  String get store_map => 'Stores Map';

  @override
  String get your_reviews => 'Your Reviews';

  @override
  String get chat_with_ai => 'Chat with AI';

  @override
  String get processing_code => 'Processing Code';

  @override
  String get align_qr_code => 'Align QR Code';

  @override
  String get error_processing_code => 'Error Processing Code';

  @override
  String get edit_info => 'Edit Info.';

  @override
  String get received_reviews => 'Received Reviews';

  @override
  String get played_with => 'Played with';

  @override
  String welcome_to_roll_and_reserve(String name) {
    return 'Welcome to Roll & Reserve, $name!';
  }

  @override
  String get find_your_ideal_game_table =>
      'Find your ideal game table and reserve in seconds.';

  @override
  String get discover_nearby_shops => 'Discover shops near you';

  @override
  String get explore_shops_with_tables =>
      'Explore shops with available tables and community ratings';

  @override
  String get reserve_in_few_steps => 'Reserve in a few steps';

  @override
  String get select_date_time_materials =>
      'Select date, time, and necessary materials for your game';

  @override
  String get manage_your_experience => 'Manage your experience';

  @override
  String get control_reservations_reviews_settings =>
      'Control your reservations, reviews, and settings from one place. Now you can even ask the AI your questions.';

  @override
  String get skip => 'Skip';

  @override
  String get get_started => 'Get Started';

  @override
  String welcome_store_owner(String name) {
    return 'Welcome $name, Store Owner!';
  }

  @override
  String get manage_your_game_space =>
      'Manage your game space professionally and efficiently';

  @override
  String get setup_your_store => 'Set Up Your Store';

  @override
  String get add_location_and_details =>
      'Add location and details of your establishment';

  @override
  String get manage_tables => 'Manage Tables';

  @override
  String get create_and_edit_tables =>
      'Create and edit available tables\nManage capacities and special features';

  @override
  String get schedule_events => 'Schedule Events';

  @override
  String get organize_tournaments_and_activities =>
      'Organize tournaments and special activities\nControl capacities and reservations';

  @override
  String get analyze_and_improve => 'Analyze and Improve';

  @override
  String get monitor_reservations_reviews_statistics =>
      'Monitor reservations, reviews, and statistics\nMake data-driven decisions';

  @override
  String get go_to_home => 'Go to Home';

  @override
  String get role_admin => 'Admin';

  @override
  String get role_user => 'User';

  @override
  String get role_owner => 'Owner';

  @override
  String get role => 'Role';

  @override
  String get error_select_user => 'Error selecting user';

  @override
  String get select_user => 'Select User';

  @override
  String get all_users => 'These are all the users';

  @override
  String get all_shops => 'These are all the shops';

  @override
  String get ai_assistant => 'AI Assistant';

  @override
  String get you => 'You';

  @override
  String get restart_conversation => 'Restart Conversation';

  @override
  String get locating_you => 'Locating you...';

  @override
  String get retry => 'Retry';

  @override
  String get tap_marker_info => 'Tap on a marker for more information';

  @override
  String get play_role_with_ai => 'Play Role with AI';

  @override
  String get choose_world_adventure =>
      'Choose the world where you want to live your adventure';

  @override
  String get describe_your_adventure => 'Describe Your Adventure';

  @override
  String get enter_adventurers_description => 'Enter Adventurers Description';

  @override
  String get adventurers_description => 'Adventurers Description';

  @override
  String get start_game => 'Start Game';

  @override
  String get confirm_delete_adventure =>
      'Are you sure you want to delete this adventure? This action cannot be undone.';

  @override
  String get delete_adventure => 'Delete Adventure';

  @override
  String get error_character_data_incomplete_or_null =>
      'Error: Character data incomplete or null.';

  @override
  String get primary_attributes => 'Primary Attributes';

  @override
  String get health_and_defense => 'Health and Defense';

  @override
  String get magical_skills => 'Magical Skills';

  @override
  String get equipment_and_treasure => 'Equipment and Treasure';

  @override
  String get companion => 'Companion';

  @override
  String get strength => 'Strength';

  @override
  String get dexterity => 'Dexterity';

  @override
  String get constitution => 'Constitution';

  @override
  String get intelligence => 'Intelligence';

  @override
  String get wisdom => 'Wisdom';

  @override
  String get charisma => 'Charisma';

  @override
  String get level => 'Level';

  @override
  String get known_spells => 'Known Spells';

  @override
  String get cantrips => 'Cantrips';

  @override
  String get level_1_spell_slots => 'Level 1 Spell Slots:';

  @override
  String get setting_description => 'Describe the setting of your adventure';

  @override
  String get ask_about_rules => 'Ask your questions about the rules';

  @override
  String get identify_board_games => 'Identify board games';

  @override
  String get profile_settings => 'Profile Settings';

  @override
  String get user_management => 'User Management';

  @override
  String get chat_features => 'Chat Features';

  @override
  String get narrator => 'Narrator';

  @override
  String get game_vision_ai => 'Game Vision AI';

  @override
  String get describe_your_move => 'Describe your move';
}
