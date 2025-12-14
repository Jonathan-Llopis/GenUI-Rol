// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get accept => 'Accepter';

  @override
  String get cancel => 'Annuler';

  @override
  String get edit_shop => 'Modifier le Magasin';

  @override
  String shop_name(String shopName) {
    return 'Magasin $shopName';
  }

  @override
  String get shop_direction => 'Adresse du Magasin';

  @override
  String get shop_delete => 'Supprimer le Magasin';

  @override
  String get add_profile_image => 'Ajouter une image de profil';

  @override
  String get camera => 'Caméra';

  @override
  String get gallery => 'Galerie';

  @override
  String get login_to_continue => 'Connectez-vous pour continuer';

  @override
  String get email => 'Email';

  @override
  String get password => 'Mot de passe';

  @override
  String get please_enter_your_password => 'Veuillez entrer votre mot de passe';

  @override
  String get you_forgot_your_password => 'Vous avez oublié votre mot de passe?';

  @override
  String get dont_have_an_account_register_here =>
      'Vous n\'avez pas de compte? Inscrivez-vous ici';

  @override
  String get sign_in_to_continue => 'Connectez-vous pour continuer';

  @override
  String get username => 'Nom d\'utilisateur';

  @override
  String get name => 'Nom';

  @override
  String get confirmation_password => 'Confirmer le mot de passe';

  @override
  String table_number(int tableNumber) {
    return 'Table: $tableNumber';
  }

  @override
  String get error => 'Erreur';

  @override
  String get available_reservations => 'Réservations Disponibles';

  @override
  String get filter_by_date => 'Filtrer par date';

  @override
  String available_reservations_for_date(String date) {
    return 'Réservations Disponibles pour: $date';
  }

  @override
  String get shop_reviews => 'Avis du Magasin';

  @override
  String get rating => 'Évaluation';

  @override
  String get all_reviews => 'Tous les Avis';

  @override
  String get available_tables => 'Tables disponibles:';

  @override
  String get save => 'Enregistrer';

  @override
  String get google_login => 'Connexion Google';

  @override
  String get login => 'Connexion';

  @override
  String get email_or_username_exists =>
      'L\'email ou le nom d\'utilisateur existe déjà dans la base de données';

  @override
  String get register => 'S\'inscrire';

  @override
  String get update => 'Mettre à jour';

  @override
  String reserve_day(String dayDate) {
    return 'Jour de réservation: $dayDate';
  }

  @override
  String game_description(String gameDescription) {
    return 'Jeu: $gameDescription';
  }

  @override
  String total_players_at_table(int currentPlayers, int totalPlaces) {
    return 'Total des joueurs à la table: $currentPlayers sur $totalPlaces';
  }

  @override
  String get start_time => 'Heure de début: ';

  @override
  String get end_time => 'Heure de fin:';

  @override
  String get anonymous => 'Anonyme';

  @override
  String get total_seats_at_table => 'Places Totales à la Table';

  @override
  String get start_time_hh_mm => 'Heure de début (HH:MM)';

  @override
  String get end_time_hh_mm => 'Heure de fin (HH:MM)';

  @override
  String get description => 'Description';

  @override
  String get required_material => 'Matériel Nécessaire';

  @override
  String get difficulty => 'Difficulté';

  @override
  String get game_category => 'Catégorie de Jeu';

  @override
  String get game => 'Jeu';

  @override
  String get add_review => 'Ajouter un Avis';

  @override
  String get please_write_a_description => 'Veuillez écrire une description';

  @override
  String get create_new_table => 'Créer une Nouvelle Table';

  @override
  String get edit_table => 'Modifier la Table';

  @override
  String get table_number_text => 'Numéro de la Table';

  @override
  String get delete_table => 'Supprimer la Table';

  @override
  String get manage_reservations => 'Gérer les Réservations';

  @override
  String get confirm_delete_shop =>
      'Êtes-vous sûr de vouloir supprimer le magasin?';

  @override
  String get email_sent_reset_password =>
      'Un email a été envoyé à votre adresse pour réinitialiser votre mot de passe';

  @override
  String get user_logout => 'Déconnexion';

  @override
  String get confirm_logout =>
      'Êtes-vous sûr de vouloir vous déconnecter de l\'application?';

  @override
  String get reset_password => 'Réinitialiser le Mot de Passe';

  @override
  String get enter_your_email_to_reset_password =>
      'Entrez votre email pour réinitialiser votre mot de passe';

  @override
  String get change_password => 'Changer le Mot de Passe';

  @override
  String get current_password => 'Mot de Passe Actuel';

  @override
  String get new_password => 'Nouveau Mot de Passe';

  @override
  String get user_settings => 'Paramètres de l\'Utilisateur';

  @override
  String get confirm_delete_table =>
      'Êtes-vous sûr de vouloir supprimer la table?';

  @override
  String active_game(String gameId) {
    return 'Jeu actif: $gameId';
  }

  @override
  String get schedule => 'Horaire:';

  @override
  String day_schedule(String dayDate, String startTime, String endTime) {
    return 'Jour: $dayDate  $startTime - $endTime';
  }

  @override
  String free_places(int freePlaces) {
    return '$freePlaces places libres';
  }

  @override
  String get additional_information => 'Informations supplémentaires:';

  @override
  String get exit => 'Sortir';

  @override
  String get join => 'Rejoindre';

  @override
  String get edit_tables => 'Modifier les Tables';

  @override
  String total_tables(int totalTables) {
    return 'Total des Tables: $totalTables';
  }

  @override
  String reservations(int reservationsCount) {
    return 'Réservations: $reservationsCount';
  }

  @override
  String welcome_user(String username) {
    return 'Bienvenue $username!';
  }

  @override
  String get all_available_shops => 'Voici tous les magasins disponibles.';

  @override
  String get shops_registered_in_your_name =>
      'Magasins enregistrés à votre nom:';

  @override
  String get no_shops => 'Vous n\'avez pas de magasins';

  @override
  String get remove_filters => 'Supprimer les Filtres';

  @override
  String get filter => 'Filtrer';

  @override
  String get filter_free_tables => 'Filtrer les Tables Libres';

  @override
  String get find_your_game_table => 'Trouvez votre table de jeu';

  @override
  String get home => 'Accueil';

  @override
  String get settings => 'Paramètres';

  @override
  String get help => 'Aide';

  @override
  String get logout => 'Déconnexion';

  @override
  String get shop_name_text => 'Nom du magasin';

  @override
  String get shop_location => 'Localisation du magasin';

  @override
  String get error_loading_reservations =>
      'Erreur lors du chargement des réservations';

  @override
  String get date => 'Date';

  @override
  String get start_time_must_be_less_than_end_time =>
      'L\'heure de début doit être inférieure à l\'heure de fin';

  @override
  String get end_time_must_be_greater_than_start_time =>
      'L\'heure de fin doit être supérieure à l\'heure de début';

  @override
  String get time_already_taken_that_day =>
      'L\'heure est déjà prise ce jour-là';

  @override
  String get required_field => 'Champ obligatoire';

  @override
  String get must_be_a_number => 'Doit être un nombre';

  @override
  String get format_must_be_hh_mm => 'Le format doit être HH:MM';

  @override
  String get name_already_in_use => 'Le nom est déjà utilisé.';

  @override
  String get email_already_in_use => 'L\'email est déjà utilisé.';

  @override
  String get password_must_be_at_least_8_characters =>
      'Le mot de passe doit contenir au moins 8 caractères';

  @override
  String get password_must_contain_at_least_one_number =>
      'Le mot de passe doit contenir au moins un chiffre';

  @override
  String get password_must_contain_at_least_one_uppercase_letter =>
      'Le mot de passe doit contenir au moins une lettre majuscule';

  @override
  String get password_must_contain_at_least_one_lowercase_letter =>
      'Le mot de passe doit contenir au moins une lettre minuscule';

  @override
  String get passwords_do_not_match => 'Les mots de passe ne correspondent pas';

  @override
  String get password_is_incorrect => 'Le mot de passe est incorrect';

  @override
  String get error_validating_password =>
      'Erreur lors de la validation du mot de passe';

  @override
  String get table_number_already_exists => 'Le numéro de table existe déjà';

  @override
  String get players => 'Joueurs';

  @override
  String get email_invalid => 'Email Invalide';

  @override
  String get changeLanguage => 'Changer de langue';

  @override
  String get go_to_events => 'Aller aux Événements';

  @override
  String get events => 'Événements';

  @override
  String get your_reservations => 'Vos Réservations';

  @override
  String get select_tables_to_occupy => 'Sélectionnez les tables à occuper';

  @override
  String get select_start_date =>
      'Sélectionnez la date de début de l\'événement';

  @override
  String get start_date_not_selected => 'Date de début non sélectionnée';

  @override
  String get start_time_not_selected => 'Heure de début non sélectionnée';

  @override
  String get select_end_date => 'Sélectionnez la date de fin de l\'événement';

  @override
  String get end_date_not_selected => 'Date de fin non sélectionnée';

  @override
  String get end_date_before_start_date =>
      'La date de fin ne peut pas être antérieure à la date de début';

  @override
  String get event_same_day => 'L\'événement doit être le même jour';

  @override
  String get end_time_not_selected => 'Heure de fin non sélectionnée';

  @override
  String get game_session_not_started =>
      'La session de jeu n\'a pas encore commencé';

  @override
  String get wrong_reservation_table => 'Table de réservation incorrecte';

  @override
  String get scan_again => 'Scanner à Nouveau';

  @override
  String get grant_camera_permission => 'Accorder la permission de la caméra';

  @override
  String get location_service_disabled =>
      'Le service de localisation est désactivé.';

  @override
  String get location_permission_denied =>
      'Les permissions de localisation sont refusées.';

  @override
  String get location_permission_denied_permanently =>
      'Les permissions de localisation sont refusées de manière permanente.';

  @override
  String get reservation_confirmed => 'Votre réservation a été confirmée!';

  @override
  String get not_in_shop_location =>
      'Vous n\'êtes pas à l\'emplacement du magasin';

  @override
  String game_event(String gameEvent) {
    return 'Événement de Jeu: $gameEvent';
  }

  @override
  String event_day_date(String dayDate) {
    return 'Événement: $dayDate';
  }

  @override
  String get reserva_confirmada => 'Réservation Confirmée';

  @override
  String get select_your_location_on_map =>
      'Sélectionnez votre emplacement sur la carte:';

  @override
  String error_snapshot(String snapshotError) {
    return 'Erreur: $snapshotError';
  }

  @override
  String get store_events => 'Événements du Magasin';

  @override
  String get confirm => 'Confirmer';

  @override
  String get english => 'Anglais';

  @override
  String get spanish => 'Espagnol';

  @override
  String get french => 'Français';

  @override
  String get catalan => 'Catalan';

  @override
  String get month => 'Mois';

  @override
  String get quarter => 'Trimestre';

  @override
  String get annual => 'Annuel';

  @override
  String get total_reservations => 'Réservations Totales';

  @override
  String get active_players => 'Joueurs Actifs';

  @override
  String get peak_hours => 'Heures de Pointe';

  @override
  String get popular_games => 'Jeux Populaires';

  @override
  String total_reservations_by_period(String selectedPeriod) {
    return 'Réservations Totales pour $selectedPeriod';
  }

  @override
  String active_players_by_period(String selectedPeriod) {
    return 'Joueurs Actifs pour $selectedPeriod';
  }

  @override
  String get peak_reservation_hours => 'Heures de Réservation de Pointe';

  @override
  String get most_popular_games => 'Jeux les Plus Populaires';

  @override
  String get games => 'Jeux';

  @override
  String get ask_ai_about_rules =>
      'Demandez à l\'IA vos \nquestions sur les règles';

  @override
  String get send_message => 'Envoyer un message';

  @override
  String get loading_chat => 'Chargement du chat...';

  @override
  String get user_or_password_incorrect =>
      'Utilisateur ou mot de passe incorrect';

  @override
  String get nearby_shops => 'Magasins à Proximité';

  @override
  String get go_to_shop => 'Aller au Magasin';

  @override
  String get confirmed => 'Confirmé';

  @override
  String get pending => 'En Attente';

  @override
  String get loading => 'Chargement...';

  @override
  String get unsubscribed => 'Désabonné';

  @override
  String get subscribed => 'Abonné';

  @override
  String get latest_players => 'Derniers Joueurs';

  @override
  String get store_statistics => 'Statistiques du Magasin';

  @override
  String get seats => 'Places';

  @override
  String get store_map => 'Carte des Magasins';

  @override
  String get your_reviews => 'Vos Avis';

  @override
  String get chat_with_ai => 'Discuter avec l\'IA';

  @override
  String get processing_code => 'Traitement du code';

  @override
  String get align_qr_code => 'Aligner le code QR';

  @override
  String get error_processing_code => 'Erreur lors du traitement du code';

  @override
  String get edit_info => 'Modifier les Infor.';

  @override
  String get received_reviews => 'Avis Reçus';

  @override
  String get played_with => 'Joué avec';

  @override
  String welcome_to_roll_and_reserve(String name) {
    return 'Bienvenue sur Roll & Reserve, $name!';
  }

  @override
  String get find_your_ideal_game_table =>
      'Trouvez votre table de jeu idéale et réservez en quelques secondes.';

  @override
  String get discover_nearby_shops =>
      'Découvrez les magasins près de chez vous';

  @override
  String get explore_shops_with_tables =>
      'Explorez les magasins avec des tables disponibles et des évaluations communautaires';

  @override
  String get reserve_in_few_steps => 'Réservez en quelques étapes';

  @override
  String get select_date_time_materials =>
      'Sélectionnez la date, l\'heure et les matériaux nécessaires pour votre jeu';

  @override
  String get manage_your_experience => 'Gérez votre expérience';

  @override
  String get control_reservations_reviews_settings =>
      'Gérez vos réservations, avis et paramètres depuis un seul endroit. Vous pouvez même poser vos questions à l\'IA.';

  @override
  String get skip => 'Passer';

  @override
  String get get_started => 'Commencer';

  @override
  String welcome_store_owner(String name) {
    return 'Bienvenue $name, Propriétaire de Magasin!';
  }

  @override
  String get manage_your_game_space =>
      'Gérez votre espace de jeu de manière professionnelle et efficace';

  @override
  String get setup_your_store => 'Configurer votre Magasin';

  @override
  String get add_location_and_details =>
      'Ajoutez l\'emplacement et les détails de votre établissement';

  @override
  String get manage_tables => 'Gérer les Tables';

  @override
  String get create_and_edit_tables =>
      'Créez et modifiez les tables disponibles\nGérez les capacités et les caractéristiques spéciales';

  @override
  String get schedule_events => 'Planifier des Événements';

  @override
  String get organize_tournaments_and_activities =>
      'Organisez des tournois et des activités spéciales\nContrôlez les capacités et les réservations';

  @override
  String get analyze_and_improve => 'Analyser et Améliorer';

  @override
  String get monitor_reservations_reviews_statistics =>
      'Surveillez les réservations, avis et statistiques\nPrenez des décisions basées sur les données';

  @override
  String get go_to_home => 'Aller à l\'Accueil';

  @override
  String get role_admin => 'Admin';

  @override
  String get role_user => 'Utilisateur';

  @override
  String get role_owner => 'Propriétaire';

  @override
  String get role => 'Rôle';

  @override
  String get error_select_user =>
      'Erreur lors de la sélection de l\'utilisateur';

  @override
  String get select_user => 'Sélectionner un utilisateur';

  @override
  String get all_users => 'Voici tous les utilisateurs';

  @override
  String get all_shops => 'Voici tous les magasins';

  @override
  String get ai_assistant => 'Assistant IA';

  @override
  String get you => 'Vous';

  @override
  String get restart_conversation => 'Redémarrer la Conversation';

  @override
  String get locating_you => 'Localisation en cours...';

  @override
  String get retry => 'Réessayer';

  @override
  String get tap_marker_info =>
      'Appuyez sur un marqueur pour plus d\'informations';

  @override
  String get play_role_with_ai => 'Jouer un rôle avec l\'IA';

  @override
  String get choose_world_adventure =>
      'Choisissez le monde où vous voulez vivre votre aventure';

  @override
  String get describe_your_adventure => 'Décrivez votre aventure';

  @override
  String get enter_adventurers_description =>
      'Entrez la description des aventuriers';

  @override
  String get adventurers_description => 'Description des aventuriers';

  @override
  String get start_game => 'Commencer le Jeu';

  @override
  String get confirm_delete_adventure =>
      'Êtes-vous sûr de vouloir supprimer cette aventure? Cette action ne peut pas être annulée.';

  @override
  String get delete_adventure => 'Supprimer l\'Aventure';

  @override
  String get error_character_data_incomplete_or_null =>
      'Erreur: Données du personnage incomplètes ou nulles.';

  @override
  String get primary_attributes => 'Attributs Primaires';

  @override
  String get health_and_defense => 'Santé et Défense';

  @override
  String get magical_skills => 'Compétences Magiques';

  @override
  String get equipment_and_treasure => 'Équipement et Trésor';

  @override
  String get companion => 'Compagnon';

  @override
  String get strength => 'Force';

  @override
  String get dexterity => 'Dextérité';

  @override
  String get constitution => 'Constitution';

  @override
  String get intelligence => 'Intelligence';

  @override
  String get wisdom => 'Sagesse';

  @override
  String get charisma => 'Charisme';

  @override
  String get level => 'Niveau';

  @override
  String get known_spells => 'Sorts Connus';

  @override
  String get cantrips => 'Tours de Magie';

  @override
  String get level_1_spell_slots => 'Emplacements de Sorts de Niveau 1:';

  @override
  String get setting_description => 'Décrivez le cadre de votre aventure';

  @override
  String get ask_about_rules => 'Posez vos questions sur les règles';

  @override
  String get identify_board_games => 'Identifier les jeux de société';

  @override
  String get profile_settings => 'Paramètres du Profil';

  @override
  String get user_management => 'Gestion des Utilisateurs';

  @override
  String get chat_features => 'Fonctionnalités de Chat';

  @override
  String get narrator => 'Narrateur';

  @override
  String get game_vision_ai => 'Vision de Jeu IA';

  @override
  String get describe_your_move => 'Décrivez votre mouvement';
}
