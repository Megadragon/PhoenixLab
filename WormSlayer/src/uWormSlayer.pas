unit uWormSlayer;

interface

uses uDefenceUnit;

type
	TWormSlayer = class(TDefenceUnit)
	public
		constructor Create;
		procedure CreateAgent; override;
		procedure DeleteAgent; override;
		procedure ExterminateVirus; override;
		procedure HideAgent; override;
		procedure Scan(const ADrive: string); override;
		procedure ShowAgent; override;
		property Agent: string read FAgentName;
		property DefCon: Byte read FDefenceCondition;
		property Drive: string read FDrive;
		property Target: string read FTargetName;
	end;

var
	WormSlayer: TWormSlayer;

implementation

uses Windows, SysUtils, IniFiles;

{ TWormSlayer }

constructor TWormSlayer.Create;
begin
	FAgentName := 'WormSlayer.';
	FTargetName := 'Autorun.inf';
end;

procedure TWormSlayer.CreateAgent;
begin
	inherited;
	if (DefCon = 3) and CreateDir(Drive + Target)
		and CreateDir('\\?\' + Drive + Target + '\' + Agent)
	then FDefenceCondition := 4;
end;

procedure TWormSlayer.DeleteAgent;
begin
	inherited;
	if DefCon > 3 then begin
		if DefCon = 5 then ShowAgent;
		if RemoveDir('\\?\' + Drive + Target + '\' + Agent) and RemoveDir(Drive + Target)
		then FDefenceCondition := 3;
	end;
end;

procedure TWormSlayer.ExterminateVirus;
var
	Autorun: TIniFile;
	DangerFile: string;
	ExePos: Word;
begin
	inherited;
	if DefCon < 3 then begin
		SetFileAttributes(PChar(Target), 0);
		Autorun := TIniFile.Create(Drive + Target);
		try
			DangerFile := Autorun.ReadString('autorun', 'open', '');
			if DangerFile <> '' then begin
				ExePos := Pos('.exe', DangerFile);
				if ExePos > 0 then DangerFile := Copy(DangerFile, 1, ExePos + 3);
				if SetFileAttributes(PChar(DangerFile), 0) and DeleteFile(DangerFile)
				then FDefenceCondition := 2 else FDefenceCondition := 1;
			end;
		finally
			Autorun.Free;
		end;
		if DeleteFile(Target) and (DefCon > 1) then FDefenceCondition := 3;
	end;
end;

procedure TWormSlayer.HideAgent;
begin
	inherited;
	if DefCon = 4 then begin
		SetFileAttributes(PChar(Drive + Agent), FILE_ATTRIBUTE_DIRECTORY or AGENT_ATTRIBUTES);
		FDefenceCondition := 5;
	end;
end;

procedure TWormSlayer.Scan(const ADrive: string);
var
	AgentAttributes: Cardinal;
	AgentPath: string;
begin
	inherited;
	FDrive := ADrive;
	AgentPath := Drive + Agent;
	if FileExists(AgentPath) then begin
		AgentAttributes := GetFileAttributes(PChar(AgentPath));
		if AgentAttributes and AGENT_ATTRIBUTES > 0 then FDefenceCondition := 5
		else FDefenceCondition := 4;
	end else begin
		if FileExists(Drive + Target) then FDefenceCondition := 2
		else FDefenceCondition := 3;
	end;
end;

procedure TWormSlayer.ShowAgent;
begin
	inherited;
	if DefCon = 5 then begin
		SetFileAttributes(PChar(Drive + Agent), FILE_ATTRIBUTE_DIRECTORY);
		FDefenceCondition := 4;
	end;
end;

end.

