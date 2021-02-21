unit GBSwagger.Model.Types;

interface

uses
  {$IFNDEF DSNAP}
  Horse,
  {$ENDIF}
  System.SysUtils,
  Web.HTTPApp;

const
  SWAG_STRING  = 'string';
  SWAG_INTEGER = 'integer';

type
  TRouteCallback = {$IFNDEF HORSE} Horse.THorseCallback {$ELSE} TObject {$ENDIF};

  TGBSwaggerContentType = (gbAppJSON, gbAppXML, gbTextHtml, gbPlainText, gbMultiPartFormData, gbAppOctetStream);
  TGBSwaggerProtocol    = (gbHttp, gbHttps);
  TGBSwaggerParamType   = (gbHeader, gbBody, gbQuery, gbPath, gbFormData);
  TGBSwaggerSecurityType = (gbBasic, gbApiKey, gbOAuth2);
  TGBSwaggerSecurityFlow = (gbImplicit, gbPassword, gbApplication, gbAccessCode);

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
      function toString: string;
  end;

  TGBSwaggerProtocolHelper = record helper for TGBSwaggerProtocol
    public
      function toString: string;
  end;

  TGBSwaggerParamTypeHelper = record helper for TGBSwaggerParamType
    public
      function toString: string;
  end;

  TMethodTypeHelper = record helper for TMethodType
    public
      function toString: string;
  end;

  TGBSwaggerSecurityTypeHelper = record helper for TGBSwaggerSecurityType
    public
      function toString: string;
  end;

  TGBSwaggerSecurityFlowHelper = record helper for TGBSwaggerSecurityFlow
    public
      function toString: string;
  end;

  TGBSwaggerHTTPStatusHelper = record helper for TGBSwaggerHTTPStatus
  public
    function httpCode: Integer;
    function description: string;
  end;

implementation

{ TGBSwaggerProtocolHelper }

function TGBSwaggerProtocolHelper.toString: string;
begin
  case Self of
    gbHttp  : result := 'http';
    gbHttps : Result := 'https';
  end;
end;

{ TGBSwaggerContentTypeHelper }

function TGBSwaggerContentTypeHelper.toString: string;
begin
  case Self of
    gbAppJSON           : result := 'application/json';
    gbAppXML            : result := 'application/xml';
    gbAppOctetStream    : result := 'application/octet-stream';
    gbTextHtml          : result := 'text/html';
    gbPlainText         : result := 'text/plain';
    gbMultiPartFormData : result := 'multipart/form-data';
  end;
end;

{ TMethodTypeHelper }

function TMethodTypeHelper.toString: string;
begin
  case Self of
    mtAny    : result := 'any';
    mtGet    : result := 'get';
    mtPut    : result := 'put';
    mtPost   : result := 'post';
    mtHead   : result := 'head';
    mtDelete : result := 'delete';
    mtPatch  : result := 'patch';
  end;
end;

{ TGBSwaggerParamTypeHelper }

function TGBSwaggerParamTypeHelper.toString: string;
begin
  case Self of
    gbHeader   : Result := 'header';
    gbBody     : Result := 'body';
    gbQuery    : Result := 'query';
    gbPath     : Result := 'path';
    gbFormData : Result := 'formData';
  end;
end;

{ TGBSwaggerSecurityTypeHelper }

function TGBSwaggerSecurityTypeHelper.toString: string;
begin
  case Self of
    gbBasic  : result := 'basic';
    gbApiKey : result := 'apiKey';
    gbOAuth2 : result := 'oauth2';
  end;
end;

{ TGBSwaggerSecurityFlowHelper }

function TGBSwaggerSecurityFlowHelper.toString: string;
begin
  case Self of
    gbImplicit    : result := 'implicit';
    gbPassword    : result := 'password';
    gbApplication : result := 'application';
    gbAccessCode  : result := 'accessCode';
  end;
end;

{ TGBSwaggerHTTPStatusHelper }

function TGBSwaggerHTTPStatusHelper.description: string;
begin
  case Self of
    gbContinue                        : result := 'Continue';
    gbSwitchingProtocols              : result := 'Switching Protocols';
    gbProcessing                      : result := 'Processing';
    gbOK                              : result := 'OK';
    gbCreated                         : result := 'Created';
    gbAccepted                        : result := 'Accepted';
    gbNonAuthoritativeInformation     : result := 'Non-Authoritative Information';
    gbNoContent                       : result := 'No Content';
    gbResetContent                    : result := 'Reset Content';
    gbPartialContent                  : result := 'Partial Content';
    gbMultiStatus                     : result := 'Multi-Status';
    gbAlreadyReported                 : result := 'Already Reported';
    gbIMUsed                          : result := 'IM Used';
    gbMultipleChoices                 : result := 'Multiple Choices';
    gbMovedPermanently                : result := 'Moved Permanently';
    gbFound                           : result := 'Found';
    gbSeeOther                        : result := 'See Other';
    gbNotModified                     : result := 'Not Modified';
    gbUseProxy                        : result := 'Use Proxy';
    gbTemporaryRedirect               : result := 'Temporary Redirect';
    gbPermanentRedirect               : result := 'Permanent Redirect';
    gbBadRequest                      : result := 'Bad Request';
    gbUnauthorized                    : result := 'Unauthorized';
    gbPaymentRequired                 : result := 'Payment Required';
    gbForbidden                       : result := 'Forbidden';
    gbNotFound                        : result := 'Not Found';
    gbMethodNotAllowed                : result := 'Method Not Allowed';
    gbNotAcceptable                   : result := 'Method Not Acceptable';
    gbProxyAuthenticationRequired     : result := 'Proxy Authentication Required';
    gbRequestTimeout                  : result := 'Request Timeout';
    gbConflict                        : result := 'Conflict';
    gbGone                            : result := 'Gone';
    gbLengthRequired                  : result := 'Length Required';
    gbPreconditionFailed              : result := 'Precondition Failed';
    gbPayloadTooLarge                 : result := 'Payload Too Large';
    gbRequestURITooLong               : result := 'URI Too Long';
    gbUnsupportedMediaType            : result := 'Unsupported Media Type';
    gbRequestedRangeNotSatisfiable    : result := 'Range Not Satisfiable';
    gbExpectationFailed               : result := 'Expectation Failed';
    gbImateapot                       : result := 'I''m a Teapot ';
    gbMisdirectedRequest              : result := 'Misdirected Request';
    gbUnprocessableEntity             : result := 'Unprocessable Entity';
    gbLocked                          : result := 'Locked';
    gbFailedDependency                : result := 'Failed Dependency';
    gbUpgradeRequired                 : result := 'Upgrade Required';
    gbPreconditionRequired            : result := 'Precondition Required';
    gbTooManyRequests                 : result := 'Too Many Requests';
    gbRequestHeaderFieldsTooLarge     : result := 'Request Header Fields Too Large';
    gbConnectionClosedWithoutResponse : result := 'Connection Closed Without Response';
    gbUnavailableForLegalReasons      : result := 'Unavailable For Legal Reasons';
    gbClientClosedRequest             : result := 'Client Closed Request';
    gbInternalServerError             : result := 'Internal Server Error';
    gbNotImplemented                  : result := 'Not Implemented';
    gbBadGateway                      : result := 'Bad Gateway';
    gbServiceUnavailable              : result := 'Service Unavailable';
    gbGatewayTimeout                  : result := 'Gateway Timeout';
    gbHTTPVersionNotSupported         : result := 'HTTP Version Not Supported';
    gbVariantAlsoNegotiates           : result := 'Variant Also Negotiates';
    gbInsufficientStorage             : result := 'Insufficient Storage';
    gbLoopDetected                    : result := 'Loop Detected';
    gbNotExtended                     : result := 'Not Extended';
    gbNetworkAuthenticationRequired   : result := 'Network Authentication Required';
    gbNetworkConnectTimeoutError      : result := 'Network Connect Timeout Error';
  end;
end;

function TGBSwaggerHTTPStatusHelper.httpCode: Integer;
begin
  result := 200;
  case Self of
    gbContinue                        : result := 100;
    gbSwitchingProtocols              : result := 101;
    gbProcessing                      : result := 102;
  	gbOK                              : result := 200;
    gbCreated                         : result := 201;
    gbAccepted                        : result := 202;
    gbNonAuthoritativeInformation     : result := 203;
    gbNoContent                       : result := 204;
    gbResetContent                    : result := 205;
    gbPartialContent                  : result := 206;
    gbMultiStatus                     : result := 207;
    gbAlreadyReported                 : result := 208;
    gbIMUsed                          : result := 226;
    gbMultipleChoices                 : result := 300;
    gbMovedPermanently                : result := 301;
    gbFound                           : result := 302;
    gbSeeOther                        : result := 303;
    gbNotModified                     : result := 304;
    gbUseProxy                        : result := 305;
    gbTemporaryRedirect               : result := 307;
    gbPermanentRedirect               : result := 308;
    gbBadRequest                      : result := 400;
    gbUnauthorized                    : result := 401;
    gbPaymentRequired                 : result := 402;
    gbForbidden                       : result := 403;
    gbNotFound                        : result := 404;
    gbMethodNotAllowed                : result := 405;
    gbNotAcceptable                   : result := 406;
    gbProxyAuthenticationRequired     : result := 407;
    gbRequestTimeout                  : result := 408;
    gbConflict                        : result := 409;
    gbGone                            : result := 410;
    gbLengthRequired                  : result := 411;
    gbPreconditionFailed              : result := 412;
    gbPayloadTooLarge                 : result := 413;
    gbRequestURITooLong               : result := 414;
    gbUnsupportedMediaType            : result := 415;
    gbRequestedRangeNotSatisfiable    : result := 416;
    gbExpectationFailed               : result := 417;
    gbImateapot                       : result := 418;
    gbMisdirectedRequest              : result := 421;
    gbUnprocessableEntity             : result := 422;
    gbLocked                          : result := 423;
    gbFailedDependency                : result := 424;
    gbUpgradeRequired                 : result := 426;
    gbPreconditionRequired            : result := 428;
    gbTooManyRequests                 : result := 429;
    gbRequestHeaderFieldsTooLarge     : result := 431;
    gbConnectionClosedWithoutResponse : result := 444;
    gbUnavailableForLegalReasons      : result := 451;
    gbClientClosedRequest             : result := 499;
    gbInternalServerError             : result := 500;
    gbNotImplemented                  : result := 501;
    gbBadGateway                      : result := 502;
    gbServiceUnavailable              : result := 503;
    gbGatewayTimeout                  : result := 504;
    gbHTTPVersionNotSupported         : result := 505;
    gbVariantAlsoNegotiates           : result := 506;
    gbInsufficientStorage             : result := 507;
    gbLoopDetected                    : result := 508;
    gbNotExtended                     : result := 510;
    gbNetworkAuthenticationRequired   : result := 511;
    gbNetworkConnectTimeoutError      : result := 599;
  end;
end;

end.
