{*******************************************************}
{                                                       }
{            Delphi Visual Component Library            }
{                                                       }
{ Copyright(c) 1995-2019 Embarcadero Technologies, Inc. }
{              All rights reserved                      }
{                                                       }
{*******************************************************}

unit Vcl.Touch.GestureConsts;

interface

resourcestring
  // RTS engine
  SAddIStylusAsyncPluginError = 'Impossible d'#39'ajouter IStylusAsyncPlugin : %s';
  SAddIStylusSyncPluginError = 'Impossible d'#39'ajouter IStylusSyncPlugin : %s';
  SRemoveIStylusAsyncPluginError = 'Impossible de retirer IStylusAsyncPlugin : %s';
  SRemoveIStylusSyncPluginError = 'Impossible de retirer IStylusSyncPlugin : %s';
  SStylusHandleError = 'Impossible d'#39'obtenir ou de définir le handle de fenêtre : %s';
  SStylusEnableError = 'Impossible d'#39'activer ou de désactiver IRealTimeStylus : %s';
  SEnableRecognizerError = 'Impossible d'#39'activer ou de désactiver IGestureRecognizer : %s';
  SInitialGesturePointError = 'Impossible de récupérer le point de mouvement initial';
  SSetStylusGestureError = 'Impossible de définir les mouvements Stylus : %s';

  // TGesturePreview
  SStartPoint = 'Point de début';
  SStartPoints = 'Points de début';

  // TGestureListView
  SNameColumn = 'Nom';

  // TGestureManager
  SInvalidStreamFormat = 'Format de flux non valide';
  SControlNotFound = 'Contrôle introuvable';
  STooManyRegisteredGestures = 'Trop de mouvements enregistrés';
  SRegisteredGestureNotFound = 'Les mouvements enregistrés suivants sont introuvables :'#13#10#13#10'%s';
  SDuplicateRegisteredGestureName = 'Un mouvement enregistré, nommé %s, existe déjà.';
  SDuplicateRecordedGestureName = 'Un mouvement enregistré, nommé %s, existe déjà.';
  SInvalidGestureID = 'ID de mouvement non valide (%d)';
  SInvalidGestureName = 'Nom de mouvement non valide (%s)';

  // TGestureCollectionItem
  SDuplicateGestureName = 'Nom de mouvement dupliqué : %s';

implementation

end.
