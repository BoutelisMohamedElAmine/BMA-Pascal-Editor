{*******************************************************}
{                                                       }
{            Delphi Visual Component Library            }
{                                                       }
{ Copyright(c) 1995-2019 Embarcadero Technologies, Inc. }
{                                                       }
{      Original version written by Gustavo Daud         }
{                                                       }
{*******************************************************}

unit Vcl.Imaging.pnglang;

{$HPPEMIT LEGACYHPP}

interface

{Language strings for english}
resourcestring
  EPngInvalidCRCText = 'Cette image "Portable Network Graphics" n'#39'est pas valide car elle contient des données invalides (erreur crc)';
  EPNGInvalidIHDRText = 'Cette image "Portable Network Graphics" n'#39'a pu être chargée car l'#39'une de ses principale donnée (ihdr) doit être corrompue';
  EPNGMissingMultipleIDATText = 'Cette image "Portable Network Graphics" est invalide car elle contient des parties d'#39'image manquantes.';
  EPNGZLIBErrorText = 'Impossible de décompresser l'#39'image car elle contient des données compressées invalides.'#13#10' Description: ';
  EPNGInvalidPaletteText = 'L'#39'image "Portable Network Graphics" contient une palette invalide.';
  EPNGInvalidFileHeaderText = 'Le fichier lu n'#39'est pas une image PNG (Portable Network Graphics) valide car il contient un en-tête non valide. Il est possible que ce fichier soit endommagé, essayez de l'#39'obtenir à nouveau';
  EPNGIHDRNotFirstText = 'Cette image "Portable Network Graphics" n'#39'est pas supportée ou doit être invalide.'#13#10'(la partie IHDR n'#39'est pas la première)';
  EPNGNotExistsText = 'Impossible de charger le fichier png car il n'#39'existe pas.';
  EPNGSizeExceedsText = 'Cette image PNG (Portable Network Graphics) n'#39'est pas supportée car sa largeur ou sa hauteur dépasse la taille maximale de 65535.';
  EPNGUnknownPalEntryText = 'Il n'#39'y a aucune entrée pour cette palette.';
  EPNGMissingPaletteText = 'Cette image "Portable Network Graphics" n'#39'a pu être chargée car elle utilise une table de couleur manquante.';
  EPNGUnknownCriticalChunkText = 'Cette image "Portable Network Graphics" contient une partie critique inconnue qui n'#39' pu être décodée.';
  EPNGUnknownCompressionText = 'Cette image "Portable Network Graphics" est encodée à l'#39'aide d'#39'un schémas de compression inconnu qui ne peut être décodé.';
  EPNGUnknownInterlaceText = 'Cette image "Portable Network Graphics" utilise un schémas d'#39'entrelacement inconnu qui ne peut être décodé.';
  EPNGUnknownColorTypeText = 'Cette image PNG (Portable Network Graphics) utilise un type de couleur inconnu n'#39'ayant pas pu être décodé.';
  EPNGCannotAssignChunkText = 'Ce morceau doit être compatible pour être assigné.';
  EPNGUnexpectedEndText = 'Cette image "Portable Network Graphics" est invalide car le décodeur est arrivé à une fin de fichier non attendue.';
  EPNGNoImageDataText = 'Cette image "Portable Network Graphics" ne contient pas de données.';
  EPNGCannotAddChunkText = 'Le programme a essayé d'#39'ajouter un morceau critique existant à l'#39'image actuelle, ce qui n'#39'est pas autorisé.';
  EPNGCannotAddInvalidImageText = 'Il n'#39'est pas permis d'#39'ajouter un nouveau morceau car l'#39'image actuelle est invalide.';
  EPNGCouldNotLoadResourceText = 'L'#39'image png n'#39'a pu être chargée depuis l'#39'ID ressource.';
  EPNGOutMemoryText = 'Certaines opérations n'#39'ont pu être effectuée car le système n'#39'a plus de ressources. Fermez quelques fenêtres et essayez à nouveau.';
  EPNGCannotChangeTransparentText = 'Définir le bit de transparence n'#39'est pas permis pour des images png qui contiennent une valeur alpha pour chaque pixel (COLOR_RGBALPHA et COLOR_GRAYSCALEALPHA)';
  EPNGHeaderNotPresentText = 'Cette opération n'#39'est pas valide car l'#39'image actuelle ne contient pas de header valide.';
  EInvalidNewSize = 'La nouvelle taille fournie pour le redimensionnement de l'#39'image est incorrecte.';
  EInvalidSpec = 'Impossible de créer le format PNG (Portable Network Graphics) car des paramètres de type d'#39'image incorrects ont été fournis.';
  EPNGInvalidBitDepthText = 'Impossible de charger l'#39'imaget PNG (Portable Network Graphics) car elle utilise des paramètres de profondeur de couleur incorrects.';


implementation

end.
