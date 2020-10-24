import 'constant.dart';

const api_url = 'http://' + server_ip + ':$server_port' + '/api';

/// User Feature
const user_api_url = api_url + '/user';

const login_url = user_api_url + '/login/';
const create_url = user_api_url + '/create/';

const me_url = user_api_url + '/me/';
const member_url = user_api_url + '/member';

String getMember(int id) => member_url + '/$id';

/// Post Feature
const post_sys_api_url = api_url + '/post_sys';

const posts_url = post_sys_api_url + '/posts/';
const comments_url = post_sys_api_url + '/comments/';

String commentsUrl(int postId) => comments_url + '?post=$postId';
String thisPost(int postId) => posts_url + '$postId';
String thisComment(int commentId, int postId) =>
    comments_url + '$commentId/?post=$postId';
