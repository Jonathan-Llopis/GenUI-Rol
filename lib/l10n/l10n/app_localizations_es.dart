// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get accept => 'Aceptar';

  @override
  String get cancel => 'Cancelar';

  @override
  String get edit_shop => 'Editar Tienda';

  @override
  String shop_name(String shopName) {
    return 'Tienda $shopName';
  }

  @override
  String get shop_direction => 'Dirección de la Tienda';

  @override
  String get shop_delete => 'Eliminar Tienda';

  @override
  String get add_profile_image => 'Añadir una imagen de perfil';

  @override
  String get camera => 'Cámara';

  @override
  String get gallery => 'Galería';

  @override
  String get login_to_continue => 'Iniciar sesión para continuar';

  @override
  String get email => 'Correo Electrónico';

  @override
  String get password => 'Contraseña';

  @override
  String get please_enter_your_password => 'Por favor, introduce tu contraseña';

  @override
  String get you_forgot_your_password => '¿Olvidaste tu contraseña?';

  @override
  String get dont_have_an_account_register_here =>
      '¿No tienes una cuenta? Regístrate aquí';

  @override
  String get sign_in_to_continue => 'Inicia sesión para continuar';

  @override
  String get username => 'Nombre de Usuario';

  @override
  String get name => 'Nombre';

  @override
  String get confirmation_password => 'Confirmar Contraseña';

  @override
  String table_number(int tableNumber) {
    return 'Mesa: $tableNumber';
  }

  @override
  String get error => 'Error';

  @override
  String get available_reservations => 'Reservas Disponibles';

  @override
  String get filter_by_date => 'Filtrar por fecha';

  @override
  String available_reservations_for_date(String date) {
    return 'Reservas Disponibles para: $date';
  }

  @override
  String get shop_reviews => 'Reseñas de la Tienda';

  @override
  String get rating => 'Calificación';

  @override
  String get all_reviews => 'Todas las Reseñas';

  @override
  String get available_tables => 'Mesas disponibles:';

  @override
  String get save => 'Guardar';

  @override
  String get google_login => 'Iniciar sesión con Google';

  @override
  String get login => 'Iniciar Sesión';

  @override
  String get email_or_username_exists =>
      'El correo electrónico o nombre de usuario ya existe en la base de datos';

  @override
  String get register => 'Registrarse';

  @override
  String get update => 'Actualitzar';

  @override
  String reserve_day(String dayDate) {
    return 'Reserva día: $dayDate';
  }

  @override
  String game_description(String gameDescription) {
    return 'Juego: $gameDescription';
  }

  @override
  String total_players_at_table(int currentPlayers, int totalPlaces) {
    return 'Total de jugadores en mesa: $currentPlayers de $totalPlaces';
  }

  @override
  String get start_time => 'Hora de inicio:';

  @override
  String get end_time => 'Hora de fin:';

  @override
  String get anonymous => 'Anónimo';

  @override
  String get total_seats_at_table => 'Plazas Totales en Mesa';

  @override
  String get start_time_hh_mm => 'Hora de inicio (HH:MM)';

  @override
  String get end_time_hh_mm => 'Hora de fin (HH:MM)';

  @override
  String get description => 'Descripción';

  @override
  String get required_material => 'Material Necesario';

  @override
  String get difficulty => 'Dificultad';

  @override
  String get game_category => 'Categoría de Juego';

  @override
  String get game => 'Juego';

  @override
  String get add_review => 'Añadir Reseña';

  @override
  String get please_write_a_description => 'Por favor, escribe una descripción';

  @override
  String get create_new_table => 'Crear Nueva Mesa';

  @override
  String get edit_table => 'Editar Mesa';

  @override
  String get table_number_text => 'Número de la Mesa';

  @override
  String get delete_table => 'Eliminar Mesa';

  @override
  String get manage_reservations => 'Gestionar Reservas';

  @override
  String get confirm_delete_shop =>
      '¿Estás seguro que quieres eliminar la tienda?';

  @override
  String get email_sent_reset_password =>
      'Se ha enviado un correo a tu email para restablecer tu contraseña';

  @override
  String get user_logout => 'Cerrar Sesión';

  @override
  String get confirm_logout =>
      '¿Estás seguro que quieres salir de la aplicación?';

  @override
  String get reset_password => 'Recuperar Contraseña';

  @override
  String get enter_your_email_to_reset_password =>
      'Introduce tu email para restablecer tu contraseña';

  @override
  String get change_password => 'Cambiar Contraseña';

  @override
  String get current_password => 'Contraseña Actual';

  @override
  String get new_password => 'Nueva Contraseña';

  @override
  String get user_settings => 'Ajustes del Usuario';

  @override
  String get confirm_delete_table =>
      '¿Estás seguro que quieres eliminar la mesa?';

  @override
  String active_game(String gameId) {
    return 'Juego activo: $gameId';
  }

  @override
  String get schedule => 'Horario:';

  @override
  String day_schedule(String dayDate, String startTime, String endTime) {
    return 'Día: $dayDate  $startTime - $endTime';
  }

  @override
  String free_places(int freePlaces) {
    return '$freePlaces lugares libres';
  }

  @override
  String get additional_information => 'Información adicional:';

  @override
  String get exit => 'Salir';

  @override
  String get join => 'Unirse';

  @override
  String get edit_tables => 'Editar Mesas';

  @override
  String total_tables(int totalTables) {
    return 'Total de Mesas: $totalTables';
  }

  @override
  String reservations(int reservationsCount) {
    return 'Reservas: $reservationsCount';
  }

  @override
  String welcome_user(String username) {
    return 'Bienvenido $username!';
  }

  @override
  String get all_available_shops => 'Estas son todas las tiendas disponibles.';

  @override
  String get shops_registered_in_your_name =>
      'Tiendas registradas a tu nombre:';

  @override
  String get no_shops => 'No tienes tiendas';

  @override
  String get remove_filters => 'Eliminar Filtros';

  @override
  String get filter => 'Filtrar';

  @override
  String get filter_free_tables => 'Filtrar Mesas Libres';

  @override
  String get find_your_game_table => 'Encuentra tu mesa de juego';

  @override
  String get home => 'Inicio';

  @override
  String get settings => 'Configuración';

  @override
  String get help => 'Ayuda';

  @override
  String get logout => 'Cerrar Sesión';

  @override
  String get shop_name_text => 'Nombre de la tienda';

  @override
  String get shop_location => 'Localidad de la tienda';

  @override
  String get error_loading_reservations => 'Error al cargar reservas';

  @override
  String get date => 'Fecha';

  @override
  String get start_time_must_be_less_than_end_time =>
      'La hora de inicio debe ser menor que la de fin';

  @override
  String get end_time_must_be_greater_than_start_time =>
      'La hora de fin debe ser mayor que la de inicio';

  @override
  String get time_already_taken_that_day => 'La hora ya está cogida ese día';

  @override
  String get required_field => 'Campo obligatorio';

  @override
  String get must_be_a_number => 'Debe ser un número';

  @override
  String get format_must_be_hh_mm => 'El formato debe ser HH:MM';

  @override
  String get name_already_in_use => 'El nombre ya está en uso.';

  @override
  String get email_already_in_use => 'El email ya está en uso.';

  @override
  String get password_must_be_at_least_8_characters =>
      'La contraseña debe tener al menos 8 caracteres';

  @override
  String get password_must_contain_at_least_one_number =>
      'La contraseña debe contener al menos un número';

  @override
  String get password_must_contain_at_least_one_uppercase_letter =>
      'La contraseña debe contener al menos una letra mayúscula';

  @override
  String get password_must_contain_at_least_one_lowercase_letter =>
      'La contraseña debe contener al menos una letra minúscula';

  @override
  String get passwords_do_not_match => 'Las contraseñas no coinciden';

  @override
  String get password_is_incorrect => 'La contraseña no es correcta';

  @override
  String get error_validating_password => 'Error al validar la contraseña';

  @override
  String get table_number_already_exists => 'El número de mesa ya existe';

  @override
  String get players => 'Jugadores';

  @override
  String get email_invalid => 'Correo Electrónico Inválido';

  @override
  String get changeLanguage => 'Cambiar Idioma';

  @override
  String get go_to_events => 'Ir a los Eventos';

  @override
  String get events => 'Eventos';

  @override
  String get your_reservations => 'Tus Reservas';

  @override
  String get select_tables_to_occupy => 'Selecciona las mesas para ocupar';

  @override
  String get select_start_date => 'Selecciona la fecha de inicio del evento';

  @override
  String get start_date_not_selected => 'Fecha de inicio no seleccionada';

  @override
  String get start_time_not_selected => 'Hora de inicio no seleccionada';

  @override
  String get select_end_date =>
      'Selecciona la fecha de finalización del evento';

  @override
  String get end_date_not_selected => 'Fecha de finalización no seleccionada';

  @override
  String get end_date_before_start_date =>
      'La fecha de finalización no puede ser anterior a la fecha de inicio';

  @override
  String get event_same_day => 'El evento debe ser el mismo día';

  @override
  String get end_time_not_selected => 'Hora de finalización no seleccionada';

  @override
  String get game_session_not_started =>
      'La sesión de juego aún no ha comenzado';

  @override
  String get wrong_reservation_table => 'Mesa de reserva incorrecta';

  @override
  String get scan_again => 'Escanear de Nuevo';

  @override
  String get grant_camera_permission => 'Conceder permiso de cámara';

  @override
  String get location_service_disabled =>
      'El servicio de localización está desactivado.';

  @override
  String get location_permission_denied =>
      'Los permisos de localización están denegados.';

  @override
  String get location_permission_denied_permanently =>
      'Los permisos de localización están denegados permanentemente.';

  @override
  String get reservation_confirmed => '¡Tu reserva ha sido confirmada!';

  @override
  String get not_in_shop_location => 'No estás en la ubicación de la tienda';

  @override
  String game_event(String gameEvent) {
    return 'Evento de Juego: $gameEvent';
  }

  @override
  String event_day_date(String dayDate) {
    return 'Evento: $dayDate';
  }

  @override
  String get reserva_confirmada => 'Reserva Confirmada';

  @override
  String get select_your_location_on_map =>
      'Selecciona tu ubicación en el mapa:';

  @override
  String error_snapshot(String snapshotError) {
    return 'Error: $snapshotError';
  }

  @override
  String get store_events => 'Eventos de la Tienda';

  @override
  String get confirm => 'Confirmar';

  @override
  String get english => 'Inglés';

  @override
  String get spanish => 'Español';

  @override
  String get french => 'Francés';

  @override
  String get catalan => 'Catalán';

  @override
  String get month => 'Mes';

  @override
  String get quarter => 'Trimestre';

  @override
  String get annual => 'Anual';

  @override
  String get total_reservations => 'Reservas Totales';

  @override
  String get active_players => 'Jugadores Activos';

  @override
  String get peak_hours => 'Horas Pico';

  @override
  String get popular_games => 'Juegos Populares';

  @override
  String total_reservations_by_period(String selectedPeriod) {
    return 'Reservas Totales para $selectedPeriod';
  }

  @override
  String active_players_by_period(String selectedPeriod) {
    return 'Jugadores Activos para $selectedPeriod';
  }

  @override
  String get peak_reservation_hours => 'Horas Pico de Reservas';

  @override
  String get most_popular_games => 'Juegos Más Populares';

  @override
  String get games => 'Juegos';

  @override
  String get ask_ai_about_rules => 'Pregunta a la IA sobre las reglas';

  @override
  String get send_message => 'Enviar un mensaje';

  @override
  String get loading_chat => 'Cargando chat...';

  @override
  String get user_or_password_incorrect => 'Usuario o contraseña incorrectos';

  @override
  String get nearby_shops => 'Tiendas Cercanas';

  @override
  String get go_to_shop => 'Ir a la Tienda';

  @override
  String get confirmed => 'Confirmado';

  @override
  String get pending => 'Pendiente';

  @override
  String get loading => 'Cargando...';

  @override
  String get unsubscribed => 'Dado de baja';

  @override
  String get subscribed => 'Suscrito';

  @override
  String get latest_players => 'Últimos Jugadores';

  @override
  String get store_statistics => 'Estadísticas de la Tienda';

  @override
  String get seats => 'Asientos';

  @override
  String get store_map => 'Mapa de las Tiendas';

  @override
  String get your_reviews => 'Tus Reseñas';

  @override
  String get chat_with_ai => 'Chat con IA';

  @override
  String get processing_code => 'Procesando código';

  @override
  String get align_qr_code => 'Alinear código QR';

  @override
  String get error_processing_code => 'Error al procesar el código';

  @override
  String get edit_info => 'Editar Info.';

  @override
  String get received_reviews => 'Reseñas Recibidas';

  @override
  String get played_with => 'Jugado con';

  @override
  String welcome_to_roll_and_reserve(String name) {
    return 'Bienvenido a Roll & Reserve, $name!';
  }

  @override
  String get find_your_ideal_game_table =>
      'Encuentra tu mesa de juego ideal y reserva en segundos.';

  @override
  String get discover_nearby_shops => 'Descubre tiendas cercanas';

  @override
  String get explore_shops_with_tables =>
      'Explora tiendas con mesas disponibles y valoraciones de la comunidad';

  @override
  String get reserve_in_few_steps => 'Reserva en pocos pasos';

  @override
  String get select_date_time_materials =>
      'Selecciona fecha, hora y materiales necesarios para tu juego';

  @override
  String get manage_your_experience => 'Gestiona tu experiencia';

  @override
  String get control_reservations_reviews_settings =>
      'Controla tus reservas, reseñas y ajustes desde un solo lugar. Ahora incluso puedes preguntar a la IA tus dudas.';

  @override
  String get skip => 'Saltar';

  @override
  String get get_started => 'Comenzar';

  @override
  String welcome_store_owner(String name) {
    return 'Bienvenido $name, Propietario de Tienda!';
  }

  @override
  String get manage_your_game_space =>
      'Gestiona tu espacio de juego de forma profesional y eficiente';

  @override
  String get setup_your_store => 'Configura tu tienda';

  @override
  String get add_location_and_details =>
      'Añade la ubicación y detalles de tu establecimiento';

  @override
  String get manage_tables => 'Gestionar Mesas';

  @override
  String get create_and_edit_tables =>
      'Crea y edita mesas disponibles\nGestiona capacidades y características especiales';

  @override
  String get schedule_events => 'Programar Eventos';

  @override
  String get organize_tournaments_and_activities =>
      'Organiza torneos y actividades especiales\nControla capacidades y reservas';

  @override
  String get analyze_and_improve => 'Analizar y Mejorar';

  @override
  String get monitor_reservations_reviews_statistics =>
      'Monitorea reservas, reseñas y estadísticas\nToma decisiones basadas en datos';

  @override
  String get go_to_home => 'Ir a Inicio';

  @override
  String get role_admin => 'Administrador';

  @override
  String get role_user => 'Usuario';

  @override
  String get role_owner => 'Propietario';

  @override
  String get role => 'Rol';

  @override
  String get error_select_user => 'Error al seleccionar usuario';

  @override
  String get select_user => 'Seleccionar Usuario';

  @override
  String get all_users => 'Estos son todos los usuarios';

  @override
  String get all_shops => 'Estas son todas las tiendas';

  @override
  String get ai_assistant => 'Asistente de IA';

  @override
  String get you => 'Tú';

  @override
  String get restart_conversation => 'Reiniciar Conversación';

  @override
  String get locating_you => 'Localizándote...';

  @override
  String get retry => 'Reintentar';

  @override
  String get tap_marker_info => 'Toca un marcador para más información';

  @override
  String get play_role_with_ai => 'Jugar Rol con IA';

  @override
  String get choose_world_adventure =>
      'Elige el mundo donde quieres vivir tu aventura';

  @override
  String get describe_your_adventure => 'Describe tu aventura';

  @override
  String get enter_adventurers_description =>
      'Introduce la descripción de los aventureros';

  @override
  String get adventurers_description => 'Descripción de los aventureros';

  @override
  String get start_game => 'Comenzar Juego';

  @override
  String get confirm_delete_adventure =>
      '¿Estás seguro de que deseas eliminar esta aventura? Esta acción no se puede deshacer.';

  @override
  String get delete_adventure => 'Eliminar Aventura';

  @override
  String get error_character_data_incomplete_or_null =>
      'Error: Datos del personaje incompletos o nulos.';

  @override
  String get primary_attributes => 'Atributos Primarios';

  @override
  String get health_and_defense => 'Salud y Defensa';

  @override
  String get magical_skills => 'Habilidades Mágicas';

  @override
  String get equipment_and_treasure => 'Equipo y Tesoro';

  @override
  String get companion => 'Compañero';

  @override
  String get strength => 'Fuerza';

  @override
  String get dexterity => 'Destreza';

  @override
  String get constitution => 'Constitución';

  @override
  String get intelligence => 'Inteligencia';

  @override
  String get wisdom => 'Sabiduría';

  @override
  String get charisma => 'Carisma';

  @override
  String get level => 'Nivel';

  @override
  String get known_spells => 'Hechizos Conocidos';

  @override
  String get cantrips => 'Trucos';

  @override
  String get level_1_spell_slots => 'Ranuras de Hechizos de Nivel 1:';

  @override
  String get setting_description => 'Describe el escenario de tu aventura';

  @override
  String get ask_about_rules => 'Pregunta tus dudas sobre las reglas';

  @override
  String get identify_board_games => 'Identificar juegos de mesa';

  @override
  String get profile_settings => 'Configuración del Perfil';

  @override
  String get user_management => 'Gestión de Usuarios';

  @override
  String get chat_features => 'Funciones de Chat';

  @override
  String get narrator => 'Narrador';

  @override
  String get game_vision_ai => 'Visión de Juego IA';

  @override
  String get describe_your_move => 'Describe tu jugada';
}
