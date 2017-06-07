unit TwilioIntf;

interface
uses System.Net.HttpClient, System.Net.URLClient;

type
  TTwilio = class
  protected
    FClient: THttpClient;
    FAccountSid, FAuthToken: string;
    procedure TwilioAuthEvent(const Sender: TObject; AnAuthTarget: TAuthTargetType;
      const ARealm, AURL: string; var AUserName, APassword: string; var AbortAuth: Boolean;
      var Persistence: TAuthPersistenceType);
  public
    ///<summary>Creates a client capable of sending numbers using the Twilio interface
    constructor Create(const AAccountSid, AAuthToken: string);
    destructor Destroy; override;
    ///<summary>Sends the message contained in Msg to the destination given in ToDestination
    ///</summary>
    function Send(const ToDestination, Msg: string): string;
  end;

implementation
uses System.Classes, System.SysUtils;

{ TTwilio }

procedure TTwilio.TwilioAuthEvent(const Sender: TObject; AnAuthTarget: TAuthTargetType;
  const ARealm, AURL: string; var AUserName, APassword: string;
  var AbortAuth: Boolean; var Persistence: TAuthPersistenceType);
begin
  AUserName := FAccountSid;
  APassword := FAuthToken;
end;

constructor TTwilio.Create(const AAccountSid, AAuthToken: string);
begin
  inherited Create;
  FAccountSid  := AAccountSid;
  FAuthToken := AAuthToken;

  FClient := THTTPClient.Create;
  FClient.AuthEvent := TwilioAuthEvent;
end;

destructor TTwilio.Destroy;
begin
  FClient.Free;
  inherited;
end;

function TTwilio.Send(const ToDestination, Msg: string): string;
var
  LURL: string;
  LStringList: TStrings;
  LResponseContent: TStringStream;
begin
  LStringList := TStringList.Create;
  try
    LURL := Format('https://api.twilio.com/2010-04-01/Accounts/%s/Messages', [FAccountSid]);
    LStringList.AddPair('To', ToDestination);
    LStringList.AddPair('From', '+1 832-430-1697'); // Need to get this number from Twilio, it's not apparent that this needs to be a local number
    // Or that this needs to have international SMS capability.
    LStringList.AddPair('Body', Msg);
    LResponseContent := TStringStream.Create;
    try
      FClient.Post(LURL, LStringList, LResponseContent);
      Result := LResponseContent.DataString;
    finally
      LResponseContent.Free;
    end;
  finally
    LStringList.Free;
  end;
end;

end.
