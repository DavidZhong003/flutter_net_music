import 'package:redux_logging/redux_logging.dart';
import 'package:redux_remote_devtools/redux_remote_devtools.dart';
import '../../host.dart';
///远程debug
var remoteDevelopTools = RemoteDevToolsMiddleware(LOCAL_HOST);
///日志
var loggingMiddleware = LoggingMiddleware.printer();

