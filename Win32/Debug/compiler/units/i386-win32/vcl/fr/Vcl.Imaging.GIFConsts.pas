{*******************************************************}
{                                                       }
{            Delphi Visual Component Library            }
{                                                       }
{ Copyright(c) 1995-2019 Embarcadero Technologies, Inc. }
{                                                       }
{*******************************************************}

unit Vcl.Imaging.GIFConsts;

{$HPPEMIT LEGACYHPP}

interface

////////////////////////////////////////////////////////////////////////////////
//
//                      Error messages
//
////////////////////////////////////////////////////////////////////////////////
resourcestring
  // GIF Error messages
  sOutOfData		= 'Fin prématurée des données';
  sTooManyColors	= 'Débordement de la table des couleurs';
  sBadColorIndex	= 'Indice de couleur incorrect';
  sBadColorIndexFixed	= 'Index de couleur non valide - table des couleurs étendue';
  sGIFErrorSaveEmpty	= 'Impossible d'#39'enregistrer un GIF vide';
  sBadSignature		= 'Signature GIF incorrecte';
  sScreenBadColorSize	= 'Nombre incorrect de couleurs spécifié dans le descripteur d'#39'écran';
  sImageBadColorSize	= 'Nombre incorrect de couleurs spécifié dans le descripteur d'#39'image';
  sUnknownExtension	= 'Type d'#39'extension inconnu';
  sBadExtensionLabel	= 'Introduction d'#39'extension incorrecte';
  sOutOfMemDIB		= 'Echec d'#39'allocation de la mémoire pour GIF DIB';
  sDIBCreate		= 'Impossible de créer un DIB à partir du bitmap';
  sDecodeTooFewBits	= 'Décoder le tampon de bits à l'#39'exécution';
  sDecodeCircular	= 'Entrée de la table du décodeur circulaire';
  sBadTrailer		= 'Queue d'#39'image incorrecte';
  sBadExtensionInstance	= 'Erreur interne : L'#39'instance d'#39'extension ne correspond pas au libellé d'#39'extension';
  sBadBlockSize		= 'Taille de bloc d'#39'extension d'#39'application non supportée';
  sBadBlock		= 'Type de bloc GIF inconnu';
  sUnsupportedClass	= 'Type d'#39'objet non supporté pour l'#39'opération';
  sInvalidData		= 'Données GIF incorrectes';
  sBadSize		= 'Taille d'#39'image incorrecte';
  sFailedPaste		= 'Echec de stockage GIF sur le presse-papiers';
  sTPictureConflict	= 'Une autre classe TGIFImage a déjà été recensée avec TPicture';
  sScreenSizeExceeded	= 'L'#39'image excède la taille d'#39'écran logique';
  sNoColorTable		= 'Aucune table de couleurs locale ou globale n'#39'est définie';
  sBadPixelCoordinates	= 'Coordonnées pixel incorrectes';
  sUnsupportedBitmap	= 'Format de bitmap non supporté';
  sInvalidPixelFormat	= 'PixelFormat non supporté';
  sBadDimension		= 'Dimensions de l'#39'image incorrectes';
  sNoDIB		= 'L'#39'image n'#39'a pas de DIB';
  sInvalidStream	= 'Opération flux incorrecte';
  sInvalidColor		= 'Couleur absente dans la table des couleurs';
  sInvalidBitSize	= 'Valeur Bits par pixel incorrecte';
  sEmptyColorMap	= 'La table des couleurs est vide';
  sEmptyImage		= 'L'#39'image est vide';
  sInvalidBitmapList	= 'Liste de bitmaps incorrects';
  sInvalidReduction	= 'Méthode de réduction incorrecte';
  sMultipleGCE		= 'Le cadre contient plusieurs blocs d'#39'extension de contrôles graphiques';
  sNoPalette		= 'Palette vide, incorrecte ou manquante';

////////////////////////////////////////////////////////////////////////////////
//
//                      Misc texts
//
////////////////////////////////////////////////////////////////////////////////
  // File filter name
  sGIFImageFile		= 'Image GIF';

  // Progress messages
  sProgressLoading	= 'Chargement';
  sProgressSaving	= 'Enregistrement';
  sProgressConverting	= 'Conversion';
  sProgressRendering	= 'Restitution';
  sProgressCopying	= 'Copie';
  sProgressOptimizing	= 'Optimisation';


implementation

end.
