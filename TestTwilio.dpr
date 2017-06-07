program TestTwilio;

{$APPTYPE CONSOLE}

{$R *.res}

uses
  System.SysUtils,
  TwilioIntf in 'TwilioIntf.pas';

var
  LAccountSid, LAuthToken: string;
  LTwilioClient: TTwilio;
begin
  try
    LAccountSid := ''; // AccountSid from  Twilio
    LAuthToken  := ''; // AuthToken  from  Twilio
    LTwilioClient := TTwilio.Create(LAccountSid, LAuthToken);
    LTwilioClient.Send('+65 9363 4096', 'Test From Delphi Twilio client!!!');
  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end;
end.

