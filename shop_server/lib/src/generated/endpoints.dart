/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters
// ignore_for_file: invalid_use_of_internal_member

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod/serverpod.dart' as _is;
import 'package:serverpod_auth_core_server/serverpod_auth_core_server.dart'
    as _iacs;
import 'package:serverpod_auth_idp_server/serverpod_auth_idp_server.dart'
    as _iais;
import 'package:shop_server/src/generated/order_item_request.dart' as _iu1ryrdr;
import 'package:shop_server/src/generated/product.dart' as _i8p2or4s;
import '../endpoints/admin_endpoint.dart' as _i5t1w2d2;
import '../endpoints/email_idp_endpoint.dart' as _ilutrrxn;
import '../endpoints/jwt_refresh_endpoint.dart' as _in48dm4x;
import '../endpoints/order_endpoint.dart' as _itwfdqvf;
import '../endpoints/payment_endpoint.dart' as _i529mnhp;
import '../endpoints/product_endpoint.dart' as _im5j1753;

class Endpoints extends _is.EndpointDispatch {
  @override
  void initializeEndpoints(_is.Server server) {
    var endpoints = <String, _is.Endpoint>{
      'admin': _i5t1w2d2.AdminEndpoint()..initialize(server, 'admin', null),
      'emailIdp': _ilutrrxn.EmailIdpEndpoint()
        ..initialize(server, 'emailIdp', null),
      'refreshJwtTokens': _in48dm4x.RefreshJwtTokensEndpoint()
        ..initialize(server, 'refreshJwtTokens', null),
      'order': _itwfdqvf.OrderEndpoint()..initialize(server, 'order', null),
      'payment': _i529mnhp.PaymentEndpoint()
        ..initialize(server, 'payment', null),
      'product': _im5j1753.ProductEndpoint()
        ..initialize(server, 'product', null),
    };
    connectors['admin'] = _is.EndpointConnector(
      name: 'admin',
      endpoint: endpoints['admin']!,
      methodConnectors: {
        'isAdmin': _is.MethodConnector(
          name: 'isAdmin',
          params: {},
          call: (_is.Session session, Map<String, dynamic> params) async =>
              (endpoints['admin'] as _i5t1w2d2.AdminEndpoint).isAdmin(session),
        ),
        'myUserId': _is.MethodConnector(
          name: 'myUserId',
          params: {},
          call: (_is.Session session, Map<String, dynamic> params) async =>
              (endpoints['admin'] as _i5t1w2d2.AdminEndpoint).myUserId(session),
        ),
        'listAllProducts': _is.MethodConnector(
          name: 'listAllProducts',
          params: {
            'limit': _is.ParameterDescription(
              name: 'limit',
              type: _is.getType<int>(),
              nullable: false,
            ),
            'offset': _is.ParameterDescription(
              name: 'offset',
              type: _is.getType<int>(),
              nullable: false,
            ),
          },
          call: (_is.Session session, Map<String, dynamic> params) async =>
              (endpoints['admin'] as _i5t1w2d2.AdminEndpoint).listAllProducts(
                session,
                limit: params['limit'],
                offset: params['offset'],
              ),
        ),
        'saveProduct': _is.MethodConnector(
          name: 'saveProduct',
          params: {
            'product': _is.ParameterDescription(
              name: 'product',
              type: _is.getType<_i8p2or4s.Product>(),
              nullable: false,
            ),
          },
          call: (_is.Session session, Map<String, dynamic> params) async =>
              (endpoints['admin'] as _i5t1w2d2.AdminEndpoint).saveProduct(
                session,
                params['product'],
              ),
        ),
        'deleteProduct': _is.MethodConnector(
          name: 'deleteProduct',
          params: {
            'productId': _is.ParameterDescription(
              name: 'productId',
              type: _is.getType<int>(),
              nullable: false,
            ),
          },
          call: (_is.Session session, Map<String, dynamic> params) async =>
              (endpoints['admin'] as _i5t1w2d2.AdminEndpoint).deleteProduct(
                session,
                params['productId'],
              ),
        ),
      },
    );
    connectors['emailIdp'] = _is.EndpointConnector(
      name: 'emailIdp',
      endpoint: endpoints['emailIdp']!,
      methodConnectors: {
        'login': _is.MethodConnector(
          name: 'login',
          params: {
            'email': _is.ParameterDescription(
              name: 'email',
              type: _is.getType<String>(),
              nullable: false,
            ),
            'password': _is.ParameterDescription(
              name: 'password',
              type: _is.getType<String>(),
              nullable: false,
            ),
          },
          call: (_is.Session session, Map<String, dynamic> params) async =>
              (endpoints['emailIdp'] as _ilutrrxn.EmailIdpEndpoint).login(
                session,
                email: params['email'],
                password: params['password'],
              ),
        ),
        'startRegistration': _is.MethodConnector(
          name: 'startRegistration',
          params: {
            'email': _is.ParameterDescription(
              name: 'email',
              type: _is.getType<String>(),
              nullable: false,
            ),
          },
          call: (_is.Session session, Map<String, dynamic> params) async =>
              (endpoints['emailIdp'] as _ilutrrxn.EmailIdpEndpoint)
                  .startRegistration(session, email: params['email']),
        ),
        'verifyRegistrationCode': _is.MethodConnector(
          name: 'verifyRegistrationCode',
          params: {
            'accountRequestId': _is.ParameterDescription(
              name: 'accountRequestId',
              type: _is.getType<_is.UuidValue>(),
              nullable: false,
            ),
            'verificationCode': _is.ParameterDescription(
              name: 'verificationCode',
              type: _is.getType<String>(),
              nullable: false,
            ),
          },
          call: (_is.Session session, Map<String, dynamic> params) async =>
              (endpoints['emailIdp'] as _ilutrrxn.EmailIdpEndpoint)
                  .verifyRegistrationCode(
                    session,
                    accountRequestId: params['accountRequestId'],
                    verificationCode: params['verificationCode'],
                  ),
        ),
        'finishRegistration': _is.MethodConnector(
          name: 'finishRegistration',
          params: {
            'registrationToken': _is.ParameterDescription(
              name: 'registrationToken',
              type: _is.getType<String>(),
              nullable: false,
            ),
            'password': _is.ParameterDescription(
              name: 'password',
              type: _is.getType<String>(),
              nullable: false,
            ),
          },
          call: (_is.Session session, Map<String, dynamic> params) async =>
              (endpoints['emailIdp'] as _ilutrrxn.EmailIdpEndpoint)
                  .finishRegistration(
                    session,
                    registrationToken: params['registrationToken'],
                    password: params['password'],
                  ),
        ),
        'startPasswordReset': _is.MethodConnector(
          name: 'startPasswordReset',
          params: {
            'email': _is.ParameterDescription(
              name: 'email',
              type: _is.getType<String>(),
              nullable: false,
            ),
          },
          call: (_is.Session session, Map<String, dynamic> params) async =>
              (endpoints['emailIdp'] as _ilutrrxn.EmailIdpEndpoint)
                  .startPasswordReset(session, email: params['email']),
        ),
        'verifyPasswordResetCode': _is.MethodConnector(
          name: 'verifyPasswordResetCode',
          params: {
            'passwordResetRequestId': _is.ParameterDescription(
              name: 'passwordResetRequestId',
              type: _is.getType<_is.UuidValue>(),
              nullable: false,
            ),
            'verificationCode': _is.ParameterDescription(
              name: 'verificationCode',
              type: _is.getType<String>(),
              nullable: false,
            ),
          },
          call: (_is.Session session, Map<String, dynamic> params) async =>
              (endpoints['emailIdp'] as _ilutrrxn.EmailIdpEndpoint)
                  .verifyPasswordResetCode(
                    session,
                    passwordResetRequestId: params['passwordResetRequestId'],
                    verificationCode: params['verificationCode'],
                  ),
        ),
        'finishPasswordReset': _is.MethodConnector(
          name: 'finishPasswordReset',
          params: {
            'finishPasswordResetToken': _is.ParameterDescription(
              name: 'finishPasswordResetToken',
              type: _is.getType<String>(),
              nullable: false,
            ),
            'newPassword': _is.ParameterDescription(
              name: 'newPassword',
              type: _is.getType<String>(),
              nullable: false,
            ),
          },
          call: (_is.Session session, Map<String, dynamic> params) async =>
              (endpoints['emailIdp'] as _ilutrrxn.EmailIdpEndpoint)
                  .finishPasswordReset(
                    session,
                    finishPasswordResetToken:
                        params['finishPasswordResetToken'],
                    newPassword: params['newPassword'],
                  ),
        ),
        'hasAccount': _is.MethodConnector(
          name: 'hasAccount',
          params: {},
          call: (_is.Session session, Map<String, dynamic> params) async =>
              (endpoints['emailIdp'] as _ilutrrxn.EmailIdpEndpoint).hasAccount(
                session,
              ),
        ),
      },
    );
    connectors['refreshJwtTokens'] = _is.EndpointConnector(
      name: 'refreshJwtTokens',
      endpoint: endpoints['refreshJwtTokens']!,
      methodConnectors: {
        'refreshAccessToken': _is.MethodConnector(
          name: 'refreshAccessToken',
          params: {
            'refreshToken': _is.ParameterDescription(
              name: 'refreshToken',
              type: _is.getType<String?>(),
              nullable: true,
            ),
          },
          call: (_is.Session session, Map<String, dynamic> params) async =>
              (endpoints['refreshJwtTokens']
                      as _in48dm4x.RefreshJwtTokensEndpoint)
                  .refreshAccessToken(
                    session,
                    refreshToken: params['refreshToken'],
                  ),
        ),
      },
    );
    connectors['order'] = _is.EndpointConnector(
      name: 'order',
      endpoint: endpoints['order']!,
      methodConnectors: {
        'createOrder': _is.MethodConnector(
          name: 'createOrder',
          params: {
            'items': _is.ParameterDescription(
              name: 'items',
              type: _is.getType<List<_iu1ryrdr.OrderItemRequest>>(),
              nullable: false,
            ),
          },
          call: (_is.Session session, Map<String, dynamic> params) async =>
              (endpoints['order'] as _itwfdqvf.OrderEndpoint).createOrder(
                session,
                params['items'],
              ),
        ),
        'myOrders': _is.MethodConnector(
          name: 'myOrders',
          params: {},
          call: (_is.Session session, Map<String, dynamic> params) async =>
              (endpoints['order'] as _itwfdqvf.OrderEndpoint).myOrders(session),
        ),
      },
    );
    connectors['payment'] = _is.EndpointConnector(
      name: 'payment',
      endpoint: endpoints['payment']!,
      methodConnectors: {
        'startMpesaPayment': _is.MethodConnector(
          name: 'startMpesaPayment',
          params: {
            'orderId': _is.ParameterDescription(
              name: 'orderId',
              type: _is.getType<int>(),
              nullable: false,
            ),
            'phoneNumber': _is.ParameterDescription(
              name: 'phoneNumber',
              type: _is.getType<String>(),
              nullable: false,
            ),
          },
          call: (_is.Session session, Map<String, dynamic> params) async =>
              (endpoints['payment'] as _i529mnhp.PaymentEndpoint)
                  .startMpesaPayment(
                    session,
                    params['orderId'],
                    params['phoneNumber'],
                  ),
        ),
        'getPaymentStatus': _is.MethodConnector(
          name: 'getPaymentStatus',
          params: {
            'orderId': _is.ParameterDescription(
              name: 'orderId',
              type: _is.getType<int>(),
              nullable: false,
            ),
          },
          call: (_is.Session session, Map<String, dynamic> params) async =>
              (endpoints['payment'] as _i529mnhp.PaymentEndpoint)
                  .getPaymentStatus(session, params['orderId']),
        ),
      },
    );
    connectors['product'] = _is.EndpointConnector(
      name: 'product',
      endpoint: endpoints['product']!,
      methodConnectors: {
        'listProducts': _is.MethodConnector(
          name: 'listProducts',
          params: {
            'search': _is.ParameterDescription(
              name: 'search',
              type: _is.getType<String?>(),
              nullable: true,
            ),
            'limit': _is.ParameterDescription(
              name: 'limit',
              type: _is.getType<int>(),
              nullable: false,
            ),
            'offset': _is.ParameterDescription(
              name: 'offset',
              type: _is.getType<int>(),
              nullable: false,
            ),
          },
          call: (_is.Session session, Map<String, dynamic> params) async =>
              (endpoints['product'] as _im5j1753.ProductEndpoint).listProducts(
                session,
                search: params['search'],
                limit: params['limit'],
                offset: params['offset'],
              ),
        ),
        'getProduct': _is.MethodConnector(
          name: 'getProduct',
          params: {
            'id': _is.ParameterDescription(
              name: 'id',
              type: _is.getType<int>(),
              nullable: false,
            ),
          },
          call: (_is.Session session, Map<String, dynamic> params) async =>
              (endpoints['product'] as _im5j1753.ProductEndpoint).getProduct(
                session,
                params['id'],
              ),
        ),
      },
    );
    modules['serverpod_auth_idp'] = _iais.Endpoints()
      ..initializeEndpoints(server);
    modules['serverpod_auth_core'] = _iacs.Endpoints()
      ..initializeEndpoints(server);
  }
}
