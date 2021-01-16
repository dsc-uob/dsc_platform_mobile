import 'constant.dart';

const api_url = 'https://api.' + domain;
const socket_url = 'wss://socket.' + domain;

/// User Feature
const user_api_url = api_url + '/user';

const login_url = user_api_url + '/login/';
const create_url = user_api_url + '/create/';

const me_url = user_api_url + '/me/';
const member_url = user_api_url + '/member';
const user_photo_url = user_api_url + '/upload-photo/';

/// Post Feature
const post_sys_api_url = api_url + '/post_sys';

const posts_url = post_sys_api_url + '/posts/';
const comments_url = post_sys_api_url + '/comments/';

/// Media urls
const media_url = api_url + '/dsc_media/';

const image_url = media_url + 'image/';

/// Chat urls
const chat_url = api_url + '/chat/';
const chat_url_ws = socket_url + '/chat/';

// HTTPS
const create_chat_session_url = chat_url + 'create/';

const chat_sessions_url = chat_url + 'session/';

const chat_roles_url = chat_url + 'role/';

const chat_messages_url = chat_url + 'message/';

// WSS
const chat_session_ws = chat_url_ws + 'session/';

const chat_messages_ws = chat_url_ws + 'messages/';
