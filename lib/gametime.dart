library gametime;

import 'dart:convert';
import 'dart:async';
import 'dart:ui' as dartui;

import 'package:meta/meta.dart';
import 'package:flutter/material.dart';

import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'package:side_header_list_view/side_header_list_view.dart';
import 'package:share/share.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:image_carousel/image_carousel.dart';
import 'package:flutter_speed_dialer/flutter_speed_dialer.dart';


import 'package:local_notifications/local_notifications.dart';
import 'package:igdb_client/igdb_client.dart';

part 'package:gametime/src/App/app.dart';
part 'package:gametime/src/App/themes.dart';

part 'package:gametime/src/Components/activity_heat_map.dart';
part 'package:gametime/src/Components/add_remove_fab.dart';
part 'package:gametime/src/Components/app_life_cycle_watcher.dart';
part 'package:gametime/src/Components/confirmation_dialog.dart';
part 'package:gametime/src/Components/game_detail_bottom_bar.dart';
part 'package:gametime/src/Components/game_grid.dart';
part 'package:gametime/src/Components/game_image.dart';
part 'package:gametime/src/Components/horizontal_chip_list.dart';
part 'package:gametime/src/Components/note_card.dart';
part 'package:gametime/src/Components/query_result.dart';
part 'package:gametime/src/Components/radio_button_list.dart';
part 'package:gametime/src/Components/session_card.dart';
part 'package:gametime/src/Components/text_card.dart';
part 'package:gametime/src/Components/custom_toggle_button.dart';
part 'package:gametime/src/Components/grow_on_click_widget.dart';
part 'package:gametime/src/Components/recent_game_card.dart';
part 'package:gametime/src/Components/recent_game_list.dart';
part 'package:gametime/src/Components/game_detail_fab_dial.dart';
part 'package:gametime/src/Components/card_horizontal_scrollable_media.dart';
part 'package:gametime/src/Components/game_detail_screenshots_card.dart';

part 'package:gametime/src/Models/activity.dart';
part 'package:gametime/src/Models/game_model.dart';
part 'package:gametime/src/Models/note.dart';
part 'package:gametime/src/Models/query.dart';
part 'package:gametime/src/Models/session.dart';

part 'package:gametime/src/Pages/activity_page.dart';
part 'package:gametime/src/Pages/add_note_page.dart';
part 'package:gametime/src/Pages/collection_page.dart';
part 'package:gametime/src/Pages/details_page.dart';
part 'package:gametime/src/Pages/edit_query_page.dart';
part 'package:gametime/src/Pages/feed_page.dart';
part 'package:gametime/src/Pages/home_page.dart';
part 'package:gametime/src/Pages/login_page.dart';
part 'package:gametime/src/Pages/main_container.dart';
part 'package:gametime/src/Pages/search_page.dart';
part 'package:gametime/src/Pages/settings_page.dart';
part 'package:gametime/src/Pages/game_info_tab.dart';
part 'package:gametime/src/Pages/game_notes_tab.dart';
part 'package:gametime/src/Pages/game_sessions_tab.dart';
part 'package:gametime/src/Pages/game_stats_tab.dart';

part 'package:gametime/src/Redux/actions.dart';
part 'package:gametime/src/Redux/app_state.dart';
part 'package:gametime/src/Redux/firebase_middleware.dart';
part 'package:gametime/src/Redux/logger_middleware.dart';
part 'package:gametime/src/Redux/reducers.dart';

part 'package:gametime/src/Services/api_keys.dart';
part 'package:gametime/src/Services/firebase_models.dart';
part 'package:gametime/src/Services/game_service_client.dart';

part 'package:gametime/src/Utils/datetime_helper.dart';
part 'package:gametime/src/Utils/notification_helper.dart';
part 'package:gametime/src/Utils/asset_helper.dart';