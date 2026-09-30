{*******************************************************}
{                                                       }
{            Delphi Visual Component Library            }
{                                                       }
{ Copyright(c) 1995-2019 Embarcadero Technologies, Inc. }
{              All rights reserved                      }
{                                                       }
{*******************************************************}

unit Vcl.ComStrs;

{$HPPEMIT LEGACYHPP}

interface

resourcestring
  sTabFailClear = 'Echec à l'#39'effacement du contrôle onglet';
  sTabFailDelete = 'Echec de la suppression de l'#39'onglet à l'#39'index %d';
  sTabFailRetrieve = 'Echec à la récupération de l'#39'onglet d'#39'indice %d';
  sTabFailGetObject = 'Echec à l'#39'obtention de l'#39'objet à l'#39'indice %d';
  sTabFailSet = 'Echec pour mettre l'#39'onglet "%s" à l'#39'indice %d';
  sTabFailSetObject = 'Echec pour mettre l'#39'objet à l'#39'indice %d';
  sTabMustBeMultiLine = 'MultiLine doit être à True quand TabPosition vaut tpLeft ou tpRight';

  sInvalidLevel = 'Affectation de niveau élément non valide';
  sInvalidLevelEx = 'Niveau non valide (%d) pour l'#39'élément "%s"';
  sInvalidIndex = 'Index incorrect';
  sInsertError = 'Impossible d'#39'insérer un élément';

  sInvalidOwner = 'Propriétaire non valide';
  sUnableToCreateColumn = 'Impossible de créer une nouvelle colonne';
  sUnableToCreateItem = 'Impossible de créer un nouvel élément';

  sRichEditInsertError = 'Erreur d'#39'insertion de ligne RichEdit';
  sRichEditLoadFail = 'Erreur au chargement du flux';
  sRichEditSaveFail = 'Erreur à l'#39'enregistrement du flux';

  sTooManyPanels = 'La barre d'#39'état ne peut avoir plus de 64 panneaux';

  sHKError = 'Erreur d'#39'affectation de raccourci clavier à %s. %s';
  sHKInvalid = 'Raccourci clavier incorrect';
  sHKInvalidWindow = 'Fenêtre incorrecte ou fenêtre enfant';
  sHKAssigned = 'Raccourci clavier affecté à une autre fenêtre';

  sUDAssociated = '%s est déjà associé à %s';

  sPageIndexError = '%d est une valeur PageIndex non valide.  PageIndex doit être compris entre 0 et %d';

  sInvalidComCtl32 = 'Ce contrôle nécessite COMCTL32.DLL version 4.70 ou supérieure';

  sDateTimeMax = 'La date dépasse le maximum de %s';
  sDateTimeMin = 'La date est inférieure au minimum de %s';
  sNeedAllowNone = 'Vous devez être en mode ShowCheckBox pour définir cette date';
  sFailSetCalDateTime = 'Echec lors du paramétrage de l'#39'heure ou de la date du calendrier';
  sFailSetCalMaxSelRange = 'Echec lors du paramétrage de l'#39'étendue de sélection maximum';
  sFailSetCalMinMaxRange = 'Echec lors du paramétrage de l'#39'étendue minimum/maximum du calendrier';
  sCalRangeNeedsMultiSelect = 'Une étendue de date ne peut être utilisée qu'#39'en mode multisélection';
  sFailsetCalSelRange = 'Echec lors du paramétrage de l'#39'étendue sélectionnée du calendrier';

implementation

end.
