{*******************************************************}
{                                                       }
{            Delphi Visual Component Library            }
{                                                       }
{ Copyright(c) 2018-2023 Embarcadero Technologies, Inc. }
{              All rights reserved                      }
{                                                       }
{*******************************************************}
{$HPPEMIT LINKUNIT}

unit Vcl.WicImageInit;

interface

implementation

uses
  Winapi.ActiveX;

initialization
  CoInitialize(nil);

end.
