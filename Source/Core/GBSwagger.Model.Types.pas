unit GBSwagger.Model.Types;

interface

uses
  {$IFNDEF DSNAP}
  Horse,
  {$ENDIF}
  System.SysUtils,
  Web.HTTPApp;

const
  SWAG_STRING = 'string';
  SWAG_INTEGER = 'integer';

type
  TRouteCallback = {$IFNDEF DSNAP} Horse.THorseCallback {$ELSE} TObject {$ENDIF};

  TGBSwaggerContentType = (gbAppJSON, gbAppXML, gbTextHtml, gbPlainText,
    gbMultiPartFormData, gbAppOctetStream);

  TGBSwaggerProtocol = (gbHttp, gbHttps);
  TGBSwaggerParamType = (gbHeader, gbBody, gbQuery, gbPath, gbFormData);
  TGBSwaggerSecurityType = (gbBasic, gbApiKey, gbOAuth2);
  TGBSwaggerSecurityFlow = (gbImplicit, gbPassword, gbApplication, gbAccessCode);
  TGBSwaggerConfigureDocExpansion = (gbNone, gbList, gbFull);

  TGBSwaggerHTTPStatus = (
    gbContinue,
    gbSwitchingProtocols,
    gbProcessing,
  	gbOK,
    gbCreated,
    gbAccepted,
    gbNonAuthoritativeInformation,
    gbNoContent,
    gbResetContent,
    gbPartialContent,
    gbMultiStatus,
    gbAlreadyReported,
    gbIMUsed,
    gbMultipleChoices,
    gbMovedPermanently,
    gbFound,
    gbSeeOther,
    gbNotModified,
    gbUseProxy,
    gbTemporaryRedirect,
    gbPermanentRedirect,
    gbBadRequest,
    gbUnauthorized,
    gbPaymentRequired,
    gbForbidden,
    gbNotFound,
    gbMethodNotAllowed,
    gbNotAcceptable,
    gbProxyAuthenticationRequired,
    gbRequestTimeout,
    gbConflict,
    gbGone,
    gbLengthRequired,
    gbPreconditionFailed,
    gbPayloadTooLarge,
    gbRequestURITooLong,
    gbUnsupportedMediaType,
    gbRequestedRangeNotSatisfiable,
    gbExpectationFailed,
    gbImateapot,
    gbMisdirectedRequest,
    gbUnprocessableEntity,
    gbLocked,
    gbFailedDependency,
    gbUpgradeRequired,
    gbPreconditionRequired,
    gbTooManyRequests,
    gbRequestHeaderFieldsTooLarge,
    gbConnectionClosedWithoutResponse,
    gbUnavailableForLegalReasons,
    gbClientClosedRequest,
    gbInternalServerError,
    gbNotImplemented,
    gbBadGateway,
    gbServiceUnavailable,
    gbGatewayTimeout,
    gbHTTPVersionNotSupported,
    gbVariantAlsoNegotiates,
    gbInsufficientStorage,
    gbLoopDetected,
    gbNotExtended,
    gbNetworkAuthenticationRequired,
    gbNetworkConnectTimeoutError);

  TGBSwaggerContentTypeHelper = record helper for TGBSwaggerContentType
  public
    function ToString: string;
  end;

  TGBSwaggerProtocolHelper = record helper for TGBSwaggerProtocol
  public
    function ToString: string;
  end;

  TGBSwaggerParamTypeHelper = record helper for TGBSwaggerParamType
  public
    function ToString: string;
  end;

  TMethodTypeHelper = record helper for TMethodType
  public
    function ToString: string;
  end;

  TGBSwaggerSecurityTypeHelper = record helper for TGBSwaggerSecurityType
  public
    function ToString: string;
  end;

  TGBSwaggerSecurityFlowHelper = record helper for TGBSwaggerSecurityFlow
  public
    function ToString: string;
  end;

  TGBSwaggerHTTPStatusHelper = record helper for TGBSwaggerHTTPStatus
  public
    function HttpCode: Integer;
    function Description: string;
  end;

  TGBSwaggerConfigureDocExpansionHelper = record helper for TGBSwaggerConfigureDocExpansion
  public
    function ToString: string;
  end;

implementation

{ TGBSwaggerProtocolHelper }

function TGBSwaggerProtocolHelper.ToString: string;
begin
  case Self of
    gbHttp: Result := 'http';
    gbHttps: Result := 'https';
  end;
end;

{ TGBSwaggerContentTypeHelper }

function TGBSwaggerContentTypeHelper.ToString: string;
begin
  case Self of
    gbAppJSON: Result := 'application/json';
    gbAppXML: Result := 'application/xml';
    gbAppOctetStream: Result := 'application/octet-stream';
    gbTextHtml: Result := 'text/html';
    gbPlainText: Result := 'text/plain';
    gbMultiPartFormData: Result := 'multipart/form-data';
  end;
end;

{ TMethodTypeHelper }

function TMethodTypeHelper.ToString: string;
begin
  case Self of
    mtAny: Result := 'any';
    mtGet: Result := 'get';
    mtPut: Result := 'put';
    mtPost: Result := 'post';
    mtHead: Result := 'head';
    mtDelete: Result := 'delete';
    mtPatch: Result := 'patch';
  end;
end;

{ TGBSwaggerParamTypeHelper }

function TGBSwaggerParamTypeHelper.ToString: string;
begin
  case Self of
    gbHeader: Result := 'header';
    gbBody: Result := 'body';
    gbQuery: Result := 'query';
    gbPath: Result := 'path';
    gbFormData: Result := 'formData';
  end;
end;

{ TGBSwaggerSecurityTypeHelper }

function TGBSwaggerSecurityTypeHelper.ToString: string;
begin
  case Self of
    gbBasic: Result := 'basic';
    gbApiKey: Result := 'apiKey';
    gbOAuth2: Result := 'oauth2';
  end;
end;

{ TGBSwaggerSecurityFlowHelper }

function TGBSwaggerSecurityFlowHelper.ToString: string;
begin
  case Self of
    gbImplicit: Result := 'implicit';
    gbPassword: Result := 'password';
    gbApplication: Result := 'application';
    gbAccessCode: Result := 'accessCode';
  end;
end;

{ TGBSwaggerHTTPStatusHelper }

function TGBSwaggerHTTPStatusHelper.description: string;
begin
  case Self of
    gbContinue: Result := 'Continue';
    gbSwitchingProtocols: Result := 'Switching Protocols';
    gbProcessing: Result := 'Processing';
    gbOK: Result := 'OK';
    gbCreated: Result := 'Created';
    gbAccepted: Result := 'Accepted';
    gbNonAuthoritativeInformation: Result := 'Non-Authoritative Information';
    gbNoContent: Result := 'No Content';
    gbResetContent: Result := 'Reset Content';
    gbPartialContent: Result := 'Partial Content';
    gbMultiStatus: Result := 'Multi-Status';
    gbAlreadyReported: Result := 'Already Reported';
    gbIMUsed: Result := 'IM Used';
    gbMultipleChoices: Result := 'Multiple Choices';
    gbMovedPermanently: Result := 'Moved Permanently';
    gbFound: Result := 'Found';
    gbSeeOther: Result := 'See Other';
    gbNotModified: Result := 'Not Modified';
    gbUseProxy: Result := 'Use Proxy';
    gbTemporaryRedirect: Result := 'Temporary Redirect';
    gbPermanentRedirect: Result := 'Permanent Redirect';
    gbBadRequest: Result := 'Bad Request';
    gbUnauthorized: Result := 'Unauthorized';
    gbPaymentRequired: Result := 'Payment Required';
    gbForbidden: Result := 'Forbidden';
    gbNotFound: Result := 'Not Found';
    gbMethodNotAllowed: Result := 'Method Not Allowed';
    gbNotAcceptable: Result := 'Method Not Acceptable';
    gbProxyAuthenticationRequired: Result := 'Proxy Authentication Required';
    gbRequestTimeout: Result := 'Request Timeout';
    gbConflict: Result := 'Conflict';
    gbGone: Result := 'Gone';
    gbLengthRequired: Result := 'Length Required';
    gbPreconditionFailed: Result := 'Precondition Failed';
    gbPayloadTooLarge: Result := 'Payload Too Large';
    gbRequestURITooLong: Result := 'URI Too Long';
    gbUnsupportedMediaType: Result := 'Unsupported Media Type';
    gbRequestedRangeNotSatisfiable: Result := 'Range Not Satisfiable';
    gbExpectationFailed: Result := 'Expectation Failed';
    gbImateapot: Result := 'I''m a Teapot ';
    gbMisdirectedRequest: Result := 'Misdirected Request';
    gbUnprocessableEntity: Result := 'Unprocessable Entity';
    gbLocked: Result := 'Locked';
    gbFailedDependency: Result := 'Failed Dependency';
    gbUpgradeRequired: Result := 'Upgrade Required';
    gbPreconditionRequired: Result := 'Precondition Required';
    gbTooManyRequests: Result := 'Too Many Requests';
    gbRequestHeaderFieldsTooLarge: Result := 'Request Header Fields Too Large';
    gbConnectionClosedWithoutResponse: Result := 'Connection Closed Without Response';
    gbUnavailableForLegalReasons: Result := 'Unavailable For Legal Reasons';
    gbClientClosedRequest: Result := 'Client Closed Request';
    gbInternalServerError: Result := 'Internal Server Error';
    gbNotImplemented: Result := 'Not Implemented';
    gbBadGateway: Result := 'Bad Gateway';
    gbServiceUnavailable: Result := 'Service Unavailable';
    gbGatewayTimeout: Result := 'Gateway Timeout';
    gbHTTPVersionNotSupported: Result := 'HTTP Version Not Supported';
    gbVariantAlsoNegotiates: Result := 'Variant Also Negotiates';
    gbInsufficientStorage: Result := 'Insufficient Storage';
    gbLoopDetected: Result := 'Loop Detected';
    gbNotExtended: Result := 'Not Extended';
    gbNetworkAuthenticationRequired: Result := 'Network Authentication Required';
    gbNetworkConnectTimeoutError: Result := 'Network Connect Timeout Error';
  end;
end;

function TGBSwaggerHTTPStatusHelper.httpCode: Integer;
begin
  Result := 200;
  case Self of
    gbContinue: Result := 100;
    gbSwitchingProtocols: Result := 101;
    gbProcessing: Result := 102;
  	gbOK: Result := 200;
    gbCreated: Result := 201;
    gbAccepted: Result := 202;
    gbNonAuthoritativeInformation: Result := 203;
    gbNoContent: Result := 204;
    gbResetContent: Result := 205;
    gbPartialContent: Result := 206;
    gbMultiStatus: Result := 207;
    gbAlreadyReported: Result := 208;
    gbIMUsed: Result := 226;
    gbMultipleChoices: Result := 300;
    gbMovedPermanently: Result := 301;
    gbFound: Result := 302;
    gbSeeOther: Result := 303;
    gbNotModified: Result := 304;
    gbUseProxy: Result := 305;
    gbTemporaryRedirect: Result := 307;
    gbPermanentRedirect: Result := 308;
    gbBadRequest: Result := 400;
    gbUnauthorized: Result := 401;
    gbPaymentRequired: Result := 402;
    gbForbidden: Result := 403;
    gbNotFound: Result := 404;
    gbMethodNotAllowed: Result := 405;
    gbNotAcceptable: Result := 406;
    gbProxyAuthenticationRequired: Result := 407;
    gbRequestTimeout: Result := 408;
    gbConflict: Result := 409;
    gbGone: Result := 410;
    gbLengthRequired: Result := 411;
    gbPreconditionFailed: Result := 412;
    gbPayloadTooLarge: Result := 413;
    gbRequestURITooLong: Result := 414;
    gbUnsupportedMediaType: Result := 415;
    gbRequestedRangeNotSatisfiable: Result := 416;
    gbExpectationFailed: Result := 417;
    gbImateapot: Result := 418;
    gbMisdirectedRequest: Result := 421;
    gbUnprocessableEntity: Result := 422;
    gbLocked: Result := 423;
    gbFailedDependency: Result := 424;
    gbUpgradeRequired: Result := 426;
    gbPreconditionRequired: Result := 428;
    gbTooManyRequests: Result := 429;
    gbRequestHeaderFieldsTooLarge: Result := 431;
    gbConnectionClosedWithoutResponse: Result := 444;
    gbUnavailableForLegalReasons: Result := 451;
    gbClientClosedRequest: Result := 499;
    gbInternalServerError: Result := 500;
    gbNotImplemented: Result := 501;
    gbBadGateway: Result := 502;
    gbServiceUnavailable: Result := 503;
    gbGatewayTimeout: Result := 504;
    gbHTTPVersionNotSupported: Result := 505;
    gbVariantAlsoNegotiates: Result := 506;
    gbInsufficientStorage: Result := 507;
    gbLoopDetected: Result := 508;
    gbNotExtended: Result := 510;
    gbNetworkAuthenticationRequired: Result := 511;
    gbNetworkConnectTimeoutError: Result := 599;
  end;
end;

{ TGBSwaggerConfigureDocExpansionHelper }

function TGBSwaggerConfigureDocExpansionHelper.ToString: String;
begin
  case Self of
    gbNone: Result := 'none';
    gbList: Result := 'list';
    gbFull: Result := 'full';
  end;
end;

end.
