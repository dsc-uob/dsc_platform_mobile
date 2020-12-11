import 'constant.dart';

const api_url = 'https://api.' + domain;
const socket_url = 'wss://socket.' + domain;

/// User Feature
const user_api_url = api_url + '/user';

const login_url = user_api_url + '/login/';
const create_url = user_api_url + '/create/';

const me_url = user_api_url + '/me/';
const member_url = user_api_url + '/member';

/// Post Feature
const post_sys_api_url = api_url + '/post_sys';

const posts_url = post_sys_api_url + '/posts/';
const comments_url = post_sys_api_url + '/comments/';

/// Media urls
const media_url = api_url + '/dsc_media/';

const image_url = media_url + 'image/';
