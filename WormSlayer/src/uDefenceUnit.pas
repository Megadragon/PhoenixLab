unit uDefenceUnit;

{
	DefCon levels:
		1 - Danger!
		2 - Virus detected!
		3 - Agent not found.
		4 - Agent decloaked.
		5 - Agent normal.
}

interface

uses Windows;

type
	TDefenceUnit = class
	protected
		FAgentName: string;
		FDefenceCondition: Byte;
		FDrive: string;
		FTargetName: string;
		procedure CreateAgent; virtual; abstract;
		procedure DeleteAgent; virtual; abstract;
		procedure ExterminateVirus; virtual; abstract;
		procedure HideAgent; virtual; abstract;
		procedure Scan(const ADrive: string); virtual; abstract;
		procedure ShowAgent; virtual; abstract;
	end;

const
	AGENT_ATTRIBUTES = FILE_ATTRIBUTE_READONLY or FILE_ATTRIBUTE_HIDDEN or FILE_ATTRIBUTE_SYSTEM;

implementation

end.

