unit uAntiRecycler;

interface

uses uDefenceUnit;

type
	TAntiRecycler = class(TDefenceUnit)
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
	AntiRecycler: TAntiRecycler;

implementation

uses Windows, SysUtils;

{ TWormSlayer }

constructor TAntiRecycler.Create;
begin
	FAgentName := 'RECYCLER';
	FTargetName := 'RECYCLER';
end;

procedure TAntiRecycler.CreateAgent;
var
	AgentFile: TextFile;
begin
	inherited;
	if DefCon = 3 then begin
		AssignFile(AgentFile, Drive + Agent);
		Rewrite(AgentFile);
		try
			WriteLn(AgentFile, '#');
		finally
			CloseFile(AgentFile);
		end;
		FDefenceCondition := 4;
	end;
end;

procedure TAntiRecycler.DeleteAgent;
begin
	inherited;
	if DefCon > 3 then begin
		if DefCon = 5 then ShowAgent;
		if DeleteFile(Drive + Agent) then FDefenceCondition := 3;
	end;
end;

procedure TAntiRecycler.ExterminateVirus;
var
	srcLinks: TSearchRec;
	NextFolder: string;
begin
	inherited;
	if DefCon < 3 then begin
		if FindFirst(Drive + '*.lnk', faAnyFile, srcLinks) = 0 then repeat
			NextFolder := ExtractFileName(srcLinks.Name);
			SetFileAttributes(PChar(srcLinks.Name), 0);
			DeleteFile(srcLinks.Name);
			SetFileAttributes(PChar(NextFolder), FILE_ATTRIBUTE_DIRECTORY);
		until FindNext(srcLinks) <> 0;
		FindClose(srcLinks);
		FDefenceCondition := 2;
		SetFileAttributes(PChar(Target), FILE_ATTRIBUTE_DIRECTORY);
		if RemoveDir(Target) then FDefenceCondition := 3;
	end;
end;

procedure TAntiRecycler.HideAgent;
begin
	inherited;
	if DefCon = 4 then begin
		SetFileAttributes(PChar(Drive + Agent), AGENT_ATTRIBUTES);
		FDefenceCondition := 5;
	end;
end;

procedure TAntiRecycler.Scan(const ADrive: string);
var
	AgentAttributes: Cardinal;
	srcLinks: TSearchRec;
begin
	inherited;
	FDrive := ADrive;
	if FileExists(Drive + Agent) then begin
		AgentAttributes := GetFileAttributes(PChar(Drive + Agent));
		if AgentAttributes and AGENT_ATTRIBUTES > 0 then FDefenceCondition := 5
		else FDefenceCondition := 4;
	end else begin
		if DirectoryExists(Drive + Target) then begin
			if FindFirst(Drive + '*.lnk', faAnyFile, srcLinks) = 0
			then FDefenceCondition := 1 else FDefenceCondition := 2;
			FindClose(srcLinks);
		end else FDefenceCondition := 3;
	end;
end;

procedure TAntiRecycler.ShowAgent;
begin
	inherited;
	if DefCon = 5 then begin
		SetFileAttributes(PChar(Drive + Agent), 0);
		FDefenceCondition := 4;
	end;
end;

end.

