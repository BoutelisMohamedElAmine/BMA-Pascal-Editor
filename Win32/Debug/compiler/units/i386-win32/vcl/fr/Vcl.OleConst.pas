{*******************************************************}
{                                                       }
{            Delphi Visual Component Library            }
{                                                       }
{ Copyright(c) 1995-2019 Embarcadero Technologies, Inc. }
{              All rights reserved                      }
{                                                       }
{*******************************************************}

unit Vcl.OleConst;

{$HPPEMIT LEGACYHPP}

interface

resourcestring
  SBadPropValue = #39'%s'#39' n'#39'est pas une valeur de propriété correcte';
  SCannotActivate = 'Echec de l'#39'activation du contrôle OLE';
  SNoWindowHandle = 'Impossible d'#39'obtenir le handle de fenêtre du contrôle OLE';
  SOleError = 'Erreur OLE %.8x';
  SVarNotObject = 'Le variant ne référence pas un objet OLE';
  SVarNotAutoObject = 'Le variant ne référence pas un objet Automation';
  SNoMethod = 'Méthode '#39'%s'#39' non supportée par l'#39'objet OLE';
  SLinkProperties = 'Propriétés de liaison';
  SInvalidLinkSource = 'Liaison impossible avec une source incorrecte.';
  SCannotBreakLink = 'Opération d'#39'interruption de liaison non supportée.';
  SLinkedObject = '%s lié(e)';
  SEmptyContainer = 'Opération non autorisée pour un conteneur OLE vide';
  SInvalidVerb = 'Verbe d'#39'objet non valide';
  SPropDlgCaption = 'Propriétés %s';
  SInvalidStreamFormat = 'Format de flux non valide';
  SInvalidLicense = 'Les informations de licence pour %s sont incorrectes';
  SNotLicensed = 'Informations de licence pour %s non trouvées. Vous ne pouvez utiliser ce contrôle en mode conception';
  sNoRunningObject = 'Impossible de récupérer un pointeur sur un objet en cours d'#39'exécution recensé avec OLE pour %s/%s';

implementation

end.

