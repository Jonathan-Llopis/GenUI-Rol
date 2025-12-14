// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Catalan Valencian (`ca`).
class AppLocalizationsCa extends AppLocalizations {
  AppLocalizationsCa([String locale = 'ca']) : super(locale);

  @override
  String get accept => 'Acceptar';

  @override
  String get cancel => 'Cancel·lar';

  @override
  String get edit_shop => 'Editar Botiga';

  @override
  String shop_name(String shopName) {
    return 'Botiga $shopName';
  }

  @override
  String get shop_direction => 'Adreça de la Botiga';

  @override
  String get shop_delete => 'Eliminar Botiga';

  @override
  String get add_profile_image => 'Afegir una imatge de perfil';

  @override
  String get camera => 'Càmera';

  @override
  String get gallery => 'Galeria';

  @override
  String get login_to_continue => 'Inicia sessió per continuar';

  @override
  String get email => 'Correu Electrònic';

  @override
  String get password => 'Contrasenya';

  @override
  String get please_enter_your_password =>
      'Si us plau, introdueix la teva contrasenya';

  @override
  String get you_forgot_your_password => 'Has oblidat la teva contrasenya?';

  @override
  String get dont_have_an_account_register_here =>
      'No tens un compte? Registra\'t aquí';

  @override
  String get sign_in_to_continue => 'Inicia sessió per continuar';

  @override
  String get username => 'Nom d\'Usuari';

  @override
  String get name => 'Nom';

  @override
  String get confirmation_password => 'Confirmar Contrasenya';

  @override
  String table_number(int tableNumber) {
    return 'Taula: $tableNumber';
  }

  @override
  String get error => 'Error';

  @override
  String get available_reservations => 'Reserves Disponibles';

  @override
  String get filter_by_date => 'Filtrar per data';

  @override
  String available_reservations_for_date(String date) {
    return 'Reserves Disponibles per a: $date';
  }

  @override
  String get shop_reviews => 'Resenyes de la Botiga';

  @override
  String get rating => 'Valoració';

  @override
  String get all_reviews => 'Totes les Resenyes';

  @override
  String get available_tables => 'Taules disponibles:';

  @override
  String get save => 'Desar';

  @override
  String get google_login => 'Iniciar sessió amb Google';

  @override
  String get login => 'Iniciar Sessió';

  @override
  String get email_or_username_exists =>
      'El correu electrònic o nom d\'usuari ja existeix a la base de dades';

  @override
  String get register => 'Registrar-se';

  @override
  String get update => 'Actualitzar';

  @override
  String reserve_day(String dayDate) {
    return 'Reserva dia: $dayDate';
  }

  @override
  String game_description(String gameDescription) {
    return 'Joc: $gameDescription';
  }

  @override
  String total_players_at_table(int currentPlayers, int totalPlaces) {
    return 'Total de jugadors a la taula: $currentPlayers de $totalPlaces';
  }

  @override
  String get start_time => 'Hora d\'inici';

  @override
  String get end_time => 'Hora de finalització:';

  @override
  String get anonymous => 'Anònim';

  @override
  String get total_seats_at_table => 'Places Totals a la Taula';

  @override
  String get start_time_hh_mm => 'Hora d\'inici (HH:MM)';

  @override
  String get end_time_hh_mm => 'Hora de finalització (HH:MM)';

  @override
  String get description => 'Descripció';

  @override
  String get required_material => 'Material Necessari';

  @override
  String get difficulty => 'Dificultat';

  @override
  String get game_category => 'Categoria de Joc';

  @override
  String get game => 'Joc';

  @override
  String get add_review => 'Afegir Resenya';

  @override
  String get please_write_a_description => 'Si us plau, escriu una descripció';

  @override
  String get create_new_table => 'Crear Nova Taula';

  @override
  String get edit_table => 'Editar Taula';

  @override
  String get table_number_text => 'Número de la Taula';

  @override
  String get delete_table => 'Eliminar Taula';

  @override
  String get manage_reservations => 'Gestionar Reserves';

  @override
  String get confirm_delete_shop => 'Estàs segur que vols eliminar la botiga?';

  @override
  String get email_sent_reset_password =>
      'S\'ha enviat un correu al teu email per restablir la teva contrasenya';

  @override
  String get user_logout => 'Tancar Sessió';

  @override
  String get confirm_logout => 'Estàs segur que vols sortir de l\'aplicació?';

  @override
  String get reset_password => 'Recuperar Contrasenya';

  @override
  String get enter_your_email_to_reset_password =>
      'Introdueix el teu email per restablir la teva contrasenya';

  @override
  String get change_password => 'Canviar Contrasenya';

  @override
  String get current_password => 'Contrasenya Actual';

  @override
  String get new_password => 'Nova Contrasenya';

  @override
  String get user_settings => 'Configuració de l\'Usuari';

  @override
  String get confirm_delete_table => 'Estàs segur que vols eliminar la taula?';

  @override
  String active_game(String gameId) {
    return 'Joc actiu: $gameId';
  }

  @override
  String get schedule => 'Horari:';

  @override
  String day_schedule(String dayDate, String startTime, String endTime) {
    return 'Dia: $dayDate  $startTime - $endTime';
  }

  @override
  String free_places(int freePlaces) {
    return '$freePlaces llocs lliures';
  }

  @override
  String get additional_information => 'Informació addicional:';

  @override
  String get exit => 'Sortir';

  @override
  String get join => 'Unir-se';

  @override
  String get edit_tables => 'Editar Taules';

  @override
  String total_tables(int totalTables) {
    return 'Total de Taules: $totalTables';
  }

  @override
  String reservations(int reservationsCount) {
    return 'Reserves: $reservationsCount';
  }

  @override
  String welcome_user(String username) {
    return 'Benvingut $username!';
  }

  @override
  String get all_available_shops =>
      'Aquestes són totes les botigues disponibles.';

  @override
  String get shops_registered_in_your_name =>
      'Botigues registrades al teu nom:';

  @override
  String get no_shops => 'No tens botigues';

  @override
  String get remove_filters => 'Eliminar Filtres';

  @override
  String get filter => 'Filtrar';

  @override
  String get filter_free_tables => 'Filtrar Taules Lliures';

  @override
  String get find_your_game_table => 'Troba la teva taula de joc';

  @override
  String get home => 'Inici';

  @override
  String get settings => 'Configuració';

  @override
  String get help => 'Ajuda';

  @override
  String get logout => 'Tancar Sessió';

  @override
  String get shop_name_text => 'Nom de la botiga';

  @override
  String get shop_location => 'Localització de la botiga';

  @override
  String get error_loading_reservations => 'Error al carregar reserves';

  @override
  String get date => 'Data';

  @override
  String get start_time_must_be_less_than_end_time =>
      'L\'hora d\'inici ha de ser menor que l\'hora de finalització';

  @override
  String get end_time_must_be_greater_than_start_time =>
      'L\'hora de finalització ha de ser major que l\'hora d\'inici';

  @override
  String get time_already_taken_that_day =>
      'L\'hora ja està ocupada aquell dia';

  @override
  String get required_field => 'Camp obligatori';

  @override
  String get must_be_a_number => 'Ha de ser un número';

  @override
  String get format_must_be_hh_mm => 'El format ha de ser HH:MM';

  @override
  String get name_already_in_use => 'El nom ja està en ús.';

  @override
  String get email_already_in_use => 'El correu electrònic ja està en ús.';

  @override
  String get password_must_be_at_least_8_characters =>
      'La contrasenya ha de tenir almenys 8 caràcters';

  @override
  String get password_must_contain_at_least_one_number =>
      'La contrasenya ha de contenir almenys un número';

  @override
  String get password_must_contain_at_least_one_uppercase_letter =>
      'La contrasenya ha de contenir almenys una lletra majúscula';

  @override
  String get password_must_contain_at_least_one_lowercase_letter =>
      'La contrasenya ha de contenir almenys una lletra minúscula';

  @override
  String get passwords_do_not_match => 'Les contrasenyes no coincideixen';

  @override
  String get password_is_incorrect => 'La contrasenya no és correcta';

  @override
  String get error_validating_password => 'Error al validar la contrasenya';

  @override
  String get table_number_already_exists => 'El número de taula ja existeix';

  @override
  String get players => 'Jugadors';

  @override
  String get email_invalid => 'Correu Electrònic Invàlid';

  @override
  String get changeLanguage => 'Canviar d\'idioma';

  @override
  String get go_to_events => 'Anar als Esdeveniments';

  @override
  String get events => 'Esdeveniments';

  @override
  String get your_reservations => 'Les Teves Reserves';

  @override
  String get select_tables_to_occupy => 'Selecciona les taules per ocupar';

  @override
  String get select_start_date =>
      'Selecciona la data d\'inici de l\'esdeveniment';

  @override
  String get start_date_not_selected => 'Data d\'inici no seleccionada';

  @override
  String get start_time_not_selected => 'Hora d\'inici no seleccionada';

  @override
  String get select_end_date =>
      'Selecciona la data de finalització de l\'esdeveniment';

  @override
  String get end_date_not_selected => 'Data de finalització no seleccionada';

  @override
  String get end_date_before_start_date =>
      'La data de finalització no pot ser anterior a la data d\'inici';

  @override
  String get event_same_day => 'L\'esdeveniment ha de ser el mateix dia';

  @override
  String get end_time_not_selected => 'Hora de finalització no seleccionada';

  @override
  String get game_session_not_started =>
      'La sessió de joc encara no ha començat';

  @override
  String get wrong_reservation_table => 'Taula de reserva incorrecta';

  @override
  String get scan_again => 'Escanejar de Nou';

  @override
  String get grant_camera_permission => 'Concedir permís de càmera';

  @override
  String get location_service_disabled =>
      'El servei de localització està desactivat.';

  @override
  String get location_permission_denied =>
      'Els permisos de localització estan denegats.';

  @override
  String get location_permission_denied_permanently =>
      'Els permisos de localització estan denegats permanentment.';

  @override
  String get reservation_confirmed => 'La teva reserva ha estat confirmada!';

  @override
  String get not_in_shop_location => 'No estàs a la ubicació de la botiga';

  @override
  String game_event(String gameEvent) {
    return 'Esdeveniment de Joc: $gameEvent';
  }

  @override
  String event_day_date(String dayDate) {
    return 'Esdeveniment: $dayDate';
  }

  @override
  String get reserva_confirmada => 'Reserva Confirmada';

  @override
  String get select_your_location_on_map =>
      'Selecciona la teva ubicació al mapa:';

  @override
  String error_snapshot(String snapshotError) {
    return 'Error: $snapshotError';
  }

  @override
  String get store_events => 'Esdeveniments de la Botiga';

  @override
  String get confirm => 'Confirmar';

  @override
  String get english => 'Anglès';

  @override
  String get spanish => 'Espanyol';

  @override
  String get french => 'Francès';

  @override
  String get catalan => 'Català';

  @override
  String get month => 'Mes';

  @override
  String get quarter => 'Trimestre';

  @override
  String get annual => 'Anual';

  @override
  String get total_reservations => 'Total Reserves';

  @override
  String get active_players => 'Jugadors Actius';

  @override
  String get peak_hours => 'Hores Punta';

  @override
  String get popular_games => 'Jocs Populars';

  @override
  String total_reservations_by_period(String selectedPeriod) {
    return 'Total de Reserves per $selectedPeriod';
  }

  @override
  String active_players_by_period(String selectedPeriod) {
    return 'Jugadors Actius per $selectedPeriod';
  }

  @override
  String get peak_reservation_hours => 'Hores Punta de Reserves';

  @override
  String get most_popular_games => 'Jocs Més Populars';

  @override
  String get games => 'Jocs';

  @override
  String get ask_ai_about_rules => 'Pregunta a la IA sobre les regles';

  @override
  String get send_message => 'Enviar un missatge';

  @override
  String get loading_chat => 'Carregant el xat...';

  @override
  String get user_or_password_incorrect => 'Usuari o contrasenya incorrecta';

  @override
  String get nearby_shops => 'Botigues Properes';

  @override
  String get go_to_shop => 'Anar a la Botiga';

  @override
  String get confirmed => 'Confirmat';

  @override
  String get pending => 'Pendent';

  @override
  String get loading => 'Carregant...';

  @override
  String get unsubscribed => 'Desubscrit';

  @override
  String get subscribed => 'Subscrit';

  @override
  String get latest_players => 'Últims Jugadors';

  @override
  String get store_statistics => 'Estadístiques de la Botiga';

  @override
  String get seats => 'Seients';

  @override
  String get store_map => 'Mapa de les Botiges';

  @override
  String get your_reviews => 'Les Teves Resenyes';

  @override
  String get chat_with_ai => 'Xateja amb la IA';

  @override
  String get processing_code => 'Processant codi';

  @override
  String get align_qr_code => 'Alinea el codi QR';

  @override
  String get error_processing_code => 'Error en processar el codi';

  @override
  String get edit_info => 'Editar Info.';

  @override
  String get received_reviews => 'Resenyes Rebudes';

  @override
  String get played_with => 'Jugat amb';

  @override
  String welcome_to_roll_and_reserve(String name) {
    return 'Benvingut a Roll & Reserve, $name!';
  }

  @override
  String get find_your_ideal_game_table =>
      'Troba la teva taula de joc ideal i reserva en segons.';

  @override
  String get discover_nearby_shops => 'Descobreix botigues properes';

  @override
  String get explore_shops_with_tables =>
      'Explora botigues amb taules disponibles i valoracions de la comunitat';

  @override
  String get reserve_in_few_steps => 'Reserva en pocs passos';

  @override
  String get select_date_time_materials =>
      'Selecciona data, hora i materials necessaris per al teu joc';

  @override
  String get manage_your_experience => 'Gestiona la teva experiència';

  @override
  String get control_reservations_reviews_settings =>
      'Controla les teves reserves, resenyes i configuracions des d\'un sol lloc. Ara també pots preguntar a la IA les teves qüestions.';

  @override
  String get skip => 'Saltar';

  @override
  String get get_started => 'Començar';

  @override
  String welcome_store_owner(String name) {
    return 'Benvingut $name, Propietari de Botiga!';
  }

  @override
  String get manage_your_game_space =>
      'Gestiona el teu espai de joc de manera professional i eficient';

  @override
  String get setup_your_store => 'Configura la teva Botiga';

  @override
  String get add_location_and_details =>
      'Afegeix la ubicació i els detalls del teu establiment';

  @override
  String get manage_tables => 'Gestiona Taules';

  @override
  String get create_and_edit_tables =>
      'Crea i edita taules disponibles\nGestiona capacitats i característiques especials';

  @override
  String get schedule_events => 'Programa Esdeveniments';

  @override
  String get organize_tournaments_and_activities =>
      'Organitza tornejos i activitats especials\nControla capacitats i reserves';

  @override
  String get analyze_and_improve => 'Analitza i Millora';

  @override
  String get monitor_reservations_reviews_statistics =>
      'Supervisa reserves, resenyes i estadístiques\nPren decisions basades en dades';

  @override
  String get go_to_home => 'Anar a Inici';

  @override
  String get role_admin => 'Administrador';

  @override
  String get role_user => 'Usuari';

  @override
  String get role_owner => 'Propietari';

  @override
  String get role => 'Rol';

  @override
  String get error_select_user => 'Error seleccionant usuari';

  @override
  String get select_user => 'Selecciona Usuari';

  @override
  String get all_users => 'Aquests són tots els usuaris';

  @override
  String get all_shops => 'Aquestes són totes les botigues';

  @override
  String get ai_assistant => 'Assistent IA';

  @override
  String get you => 'Tu';

  @override
  String get restart_conversation => 'Reiniciar Conversa';

  @override
  String get locating_you => 'Localitzant-te...';

  @override
  String get retry => 'Reintentar';

  @override
  String get tap_marker_info => 'Toca un marcador per a més informació';

  @override
  String get play_role_with_ai => 'Jugar Rol amb IA';

  @override
  String get choose_world_adventure =>
      'Tria el món on vols viure la teva aventura';

  @override
  String get describe_your_adventure => 'Descriu la teva aventura';

  @override
  String get enter_adventurers_description =>
      'Introdueix la descripció dels aventurers';

  @override
  String get adventurers_description => 'Descripció dels aventurers';

  @override
  String get start_game => 'Començar Joc';

  @override
  String get confirm_delete_adventure =>
      'Estàs segur que vols eliminar aquesta aventura? Aquesta acció no es pot desfer.';

  @override
  String get delete_adventure => 'Eliminar Aventura';

  @override
  String get error_character_data_incomplete_or_null =>
      'Error: Dades del personatge incompletes o nul·les.';

  @override
  String get primary_attributes => 'Atributs Primaris';

  @override
  String get health_and_defense => 'Salut i Defensa';

  @override
  String get magical_skills => 'Habilitats Màgiques';

  @override
  String get equipment_and_treasure => 'Equipament i Tresor';

  @override
  String get companion => 'Company';

  @override
  String get strength => 'Força';

  @override
  String get dexterity => 'Destresa';

  @override
  String get constitution => 'Constitució';

  @override
  String get intelligence => 'Intel·ligència';

  @override
  String get wisdom => 'Saviesa';

  @override
  String get charisma => 'Carisma';

  @override
  String get level => 'Nivell';

  @override
  String get known_spells => 'Encantaments Coneguts';

  @override
  String get cantrips => 'Trucs';

  @override
  String get level_1_spell_slots => 'Ranures d\'Encantaments de Nivell 1:';

  @override
  String get setting_description => 'Descriu l\'escenari de la teva aventura';

  @override
  String get ask_about_rules => 'Pregunta sobre les regles';

  @override
  String get identify_board_games => 'Identifica jocs de taula';

  @override
  String get profile_settings => 'Configuració del Perfil';

  @override
  String get user_management => 'Gestió d\'Usuaris';

  @override
  String get chat_features => 'Funcions de Xat';

  @override
  String get narrator => 'Narrador';

  @override
  String get game_vision_ai => 'Visió de Joc IA';

  @override
  String get describe_your_move => 'Descriu la teua jugada';
}
