{*******************************************************}
{                                                       }
{            Delphi Visual Component Library            }
{                                                       }
{ Copyright(c) 1995-2019 Embarcadero Technologies, Inc. }
{              All rights reserved                      }
{                                                       }
{*******************************************************}

unit Vcl.Consts;

{$HPPEMIT LEGACYHPP}

interface

resourcestring
  SSelectADate = 'sélectionner une date';
  SOpenFileTitle = 'Ouvrir';
  SCantWriteResourceStreamError = 'Impossible d'#39'écrire dans un flux en lecture seule';
  SDuplicateReference = 'WriteObject appelé deux fois pour la même instance';
  SClassMismatch = 'La ressource %s est d'#39'une classe incorrecte';
  SInvalidTabIndex = 'Index d'#39'onglet hors limites';
  SInvalidTabPosition = 'Position d'#39'onglet incompatible avec le style d'#39'onglet en cours';
  SInvalidTabStyle = 'Style d'#39'onglet incompatible avec la position d'#39'onglet en cours';
  SInvalidBitmap = 'Image de bitmap non valide';
  SInvalidIcon = 'Image d'#39'icône non valide';
  SInvalidMetafile = 'MetaFichier incorrect';
  SInvalidPixelFormat = 'Format de pixel non valide';
  SInvalidImage = 'Image non valide';
  SBitmapEmpty = 'Bitmap vide';
  SScanLine = 'Index de ligne hors limites';
  SChangeIconSize = 'Impossible de modifier la taille d'#39'une icône';
  SChangeWicSize = 'Impossible de modifier la taille d'#39'une image WIC';
  SOleGraphic = 'Opération incorrecte sur TOleGraphic';
  SUnknownExtension = 'Extension de fichier image inconnue (.%s)';
  SUnknownClipboardFormat = 'Format de Presse-papiers non supporté';
  SUnknownStreamFormat = 'Format de flux non supporté';
  SOutOfResources = 'Ressources système insuffisantes';
  SNoCanvasHandle = 'Le canevas ne permet pas de dessiner';
  SInvalidTextFormatFlag = 'Indicateur de format texte '#39'%s'#39' non supporté';
  SInvalidImageSize = 'Taille de l'#39'image non valide';
  STooManyImages = 'Trop d'#39'images';
  SDimsDoNotMatch = 'Les dimensions de l'#39'image ne correspondent pas à celles de la liste d'#39'images';
  SInvalidImageList = 'ImageList incorrecte';
  SReplaceImage = 'Impossible de remplacer l'#39'image';
  SInsertImage =  'Impossible d'#39'insérer l'#39'image';
  SImageIndexError = 'Index ImageList non valide';
  SImageReadFail = 'Erreur à la lecture des données ImageList dans le flux';
  SImageWriteFail = 'Erreur à l'#39'écriture des données ImageList dans le flux';
  SWindowDCError = 'Erreur à la création du contexte périphérique fenêtre';
  SClientNotSet = 'Client de TDrag non initialisé';
  SWindowClass = 'Erreur à la création de la classe fenêtre';
  SWindowCreate = 'Erreur à la création de fenêtre';
  SCannotFocus = 'Impossible de focaliser une fenêtre désactivée ou invisible';
  SParentRequired = 'Le contrôle '#39'%s'#39' n'#39'a pas de fenêtre parente';
  SControlPath = '. Chemin :'#13#10'%s';
  SParentGivenNotAParent = 'Le parent donné n'#39'est pas un parent de '#39'%s'#39;
  SMDIChildNotVisible = 'Impossible de cacher une fiche enfant MDI';
  SVisibleChanged = 'Impossible de changer Visible dans OnShow ou OnHide';
  SCannotShowModal = 'Impossible de rendre modale une fenêtre visible';
  SScrollBarRange = 'Propriété scrollbar hors limites';
  SPropertyOutOfRange = 'Propriété %s hors limites';
  SMenuIndexError = 'Index de menu hors limites';
  SMenuReinserted = 'Menu inséré deux fois';
  SMenuNotFound = 'Sous-menu pas dans le menu';
  SNoTimers = 'Pas assez de timers disponibles';
  SNotPrinting = 'L'#39'imprimante n'#39'imprime pas actuellement';
  SPrinting = 'Impression en cours';
  SPrinterIndexError = 'Index d'#39'imprimante hors limites';
  SInvalidPrinter = 'Imprimante sélectionnée non valide';
  SDeviceOnPort = '%s sur %s';
  SGroupIndexTooLow = 'GroupIndex ne peut être inférieur à celui de l'#39'élément de menu précédent';
  STwoMDIForms = 'Impossible d'#39'avoir plus d'#39'une fiche MDI par application';
  SNoMDIForm = 'Impossible de créer la fiche. Aucune fiche MDI n'#39'est actuellement active';
  SImageCanvasNeedsBitmap = 'Une image ne peut être modifiée que si elle contient un bitmap';
  SControlParentSetToSelf = 'Un contrôle ne peut être son propre parent';
  SOKButton = 'OK';
  SCancelButton = 'Annuler';
  SYesButton = '&Oui';
  SNoButton = '&Non';
  SHelpButton = '&Aide';
  SCloseButton = '&Fermer';
  SIgnoreButton = '&Ignorer';
  SRetryButton = '&Réessayer';
  SAbortButton = 'Abandonner';
  SAllButton = '&Tous';

  SCannotDragForm = 'Impossible de déplacer une fiche';
  SPutObjectError = 'PutObject en élément non défini';
  SCardDLLNotLoaded = 'Impossible de charger CARDS.DLL';
  SDuplicateCardId = 'CardID dupliqué';

  SDdeErr = 'Une erreur a été renvoyée par DDE ($0%x)';
  SDdeConvErr = 'Erreur DDE - Conversation non établie ($0%x)';
  SDdeMemErr = 'Erreur apparue suite à un manque de mémoire DDE ($0%x)';
  SDdeNoConnect = 'Impossible de connecter la conversation DDE';

  SFB = 'FB';
  SFG = 'FG';
  SBG = 'BG';
  SOldTShape = 'Impossible de charger une version antérieure de TShape';
  SVMetafiles = 'Métafichiers';
  SVEnhMetafiles = 'Métafichiers évolués';
  SVIcons = 'Icônes';
  SVBitmaps = 'Bitmaps';
  SVTIFFImages = 'Images TIFF'; 
{$IF DEFINED(CLR)}
  SVJPGImages = 'Images JPEG';
  SVPNGImages = 'Images PNG';
  SVGIFImages = 'Images GIF';
{$ENDIF}
  SGridTooLarge = 'Grille trop grande pour l'#39'opération';
  STooManyDeleted = 'Trop de lignes ou colonnes supprimées';
  SIndexOutOfRange = 'Indice de grille hors limites';
  SFixedColTooBig = 'Le nombre de colonnes fixes doit être inférieur au nombre de colonnes';
  SFixedRowTooBig = 'Le nombre de lignes fixes doit être inférieur au nombre de lignes';
  SInvalidStringGridOp = 'Impossible d'#39'insérer ou de supprimer les lignes de la grille';
  SInvalidEnumValue = 'Valeur enum incorrecte';
  SInvalidNumber = 'Valeur numérique non valide';
  SOutlineIndexError = 'Indice arborescence non trouvé';
  SOutlineExpandError = 'Le parent doit être développé';
  SInvalidCurrentItem = 'Valeur non valide pour l'#39'élément en cours';
  SMaskErr = 'Valeur d'#39'entrée incorrecte';
  SMaskEditErr = 'Valeur d'#39'entrée incorrecte. Utiliser Echap pour abandonner les modifications';
  SOutlineError = 'Indice arborescence incorrect';
  SOutlineBadLevel = 'Affectation de niveau incorrect';
  SOutlineSelection = 'Sélection incorrecte';
  SOutlineFileLoad = 'Erreur chargement de fichier';
  SOutlineLongLine = 'Ligne trop longue';
  SOutlineMaxLevels = 'Profondeur maximum arborescence dépassée';

  SMsgDlgWarning = 'Avertissement';
  SMsgDlgError = 'Erreur';
  SMsgDlgInformation = 'Informations';
  SMsgDlgConfirm = 'Confirmer';
  SMsgDlgYes = '&Oui';
  SMsgDlgNo = '&Non';
  SMsgDlgOK = 'OK';
  SMsgDlgCancel = 'Annuler';
  SMsgDlgHelp = '&Aide';
  SMsgDlgHelpNone = 'Aucune aide disponible';
  SMsgDlgHelpHelp = 'Aide';
  SMsgDlgAbort = 'A&bandonner';
  SMsgDlgRetry = '&Réessayer';
  SMsgDlgIgnore = '&Ignorer';
  SMsgDlgAll = '&Tous';
  SMsgDlgNoToAll = 'Non &pour tout';
  SMsgDlgYesToAll = 'O&ui pour tout';
  SMsgDlgClose = 'Fer&mer';

  SmkcBkSp = 'RetArr';
  SmkcTab = 'Tab';
  SmkcEsc = 'Echap';
  SmkcEnter = 'Entrée';
  SmkcSpace = 'Espace';
  SmkcPgUp = 'PagePréc';
  SmkcPgDn = 'PageSuiv';
  SmkcEnd = 'Fin ';
  SmkcHome = 'Origine';
  SmkcLeft = 'Gauche';
  SmkcUp = 'Haut';
  SmkcRight = 'Droite';
  SmkcDown = 'Bas';
  SmkcIns = 'Inser';
  SmkcDel = 'Suppr';
  SmkcShift = 'Maj+';
  SmkcCtrl = 'Ctrl+';
  SmkcAlt = 'Alt+';

  srUnknown = '(inconnu)';
  srNone = '(vide)';
  SOutOfRange = 'La valeur doit être comprise entre %d et %d';

  SDateEncodeError = 'Argument incorrect pour l'#39'encodage de date';
  SDefaultFilter = 'Tous les fichiers (*.*)|*.*';
  sAllFilter = 'Tous';
  SNoVolumeLabel = ': [ Pas de nom de volume ]';
  SInsertLineError = 'Impossible d'#39'insérer une ligne';

  SConfirmCreateDir = 'Le répertoire spécifié n'#39'existe pas. Voulez-vous le créer ?';
  SSelectDirCap = 'Sélectionner un répertoire';
  SDirNameCap = '&Nom du répertoire :';
  SDrivesCap = '&Lecteurs :';
  SDirsCap = '&Répertoires :';
  SFilesCap = '&Fichiers : (*.*)';
  SNetworkCap = 'Ré&seau...';

  SColorPrefix = 'Couleurs' deprecated;          //!! obsolete - delete in 5.0
  SColorTags = 'ABCDEFGHIJKLMNOP' deprecated; //!! obsolete - delete in 5.0

  SInvalidClipFmt = 'Format de Presse-papiers non valide';
  SIconToClipboard = 'Le Presse-papiers ne supporte pas les icônes';
  SCannotOpenClipboard = 'Impossible d'#39'ouvrir le Presse-papiers : %s';

  SDefault = 'Par défaut';

  SInvalidMemoSize = 'Le texte dépasse la capacité du mémo';
  SCustomColors = 'Couleurs personnalisées';
  SInvalidPrinterOp = 'Opération non supportée sur l'#39'imprimante sélectionnée';
  SNoDefaultPrinter = 'Aucune imprimante par défaut sélectionnée';

  SIniFileWriteError = 'Impossible d'#39'écrire dans %s';

  SBitsIndexError = 'Indice de bits hors limites';

  SUntitled = '(sans titre)';

  SInvalidRegType = 'Type de données incorrect pour '#39'%s'#39;

  SUnknownConversion = 'Extension de fichier de conversion RichEdit inconnue (.%s)';
  SDuplicateMenus = 'Le menu '#39'%s'#39' est déjà utilisé par une autre fiche';

  SPictureLabel = 'Image :';
  SPictureDesc = ' (%dx%d)';
  SPreviewLabel = 'Aperçu';

  SCannotOpenAVI = 'Impossible d'#39'ouvrir l'#39'AVI';

  SNotOpenErr = 'Aucun périphérique MCI ouvert';
  SMPOpenFilter = 'Tous les fichiers (*.*)|*.*|Fichiers wave (*.wav)|*.wav|Fichiers Midi (*.mid)|*.mid|Vidéo pour Windows (*.avi)|*.avi';
  SMCINil = '';
  SMCIAVIVideo = 'Vidéo AVI';
  SMCICDAudio = 'CD Audio';
  SMCIDAT = 'DAT';
  SMCIDigitalVideo = 'Vidéo numérique';
  SMCIMMMovie = 'MMMovie';
  SMCIOther = 'Autre';
  SMCIOverlay = 'Overlay';
  SMCIScanner = 'Scanner';
  SMCISequencer = 'Séquenceur';
  SMCIVCR = 'Magnétoscope';
  SMCIVideodisc = 'Vidéodisque';
  SMCIWaveAudio = 'Audio wav';
  SMCIUnknownError = 'Code d'#39'erreur inconnu';

  SBoldItalicFont = 'Gras Italique';
  SBoldFont = 'Gras';
  SItalicFont = 'Italique';
  SRegularFont = 'Normal';

  SPropertiesVerb = 'Propriétés';

  SServiceFailed = 'Le service a échoué pour %s : %s';
  SExecute = 'exécuter';
  SStart = 'lancer';
  SStop = 'arrêter';
  SPause = 'pause';
  SContinue = 'continuer';
  SInterrogate = 'interroger';
  SShutdown = 'terminer';
  SCustomError = 'Le service a échoué dans le message personnalisé (%d) : %s';
  SServiceInstallOK = 'Service installé avec succès';
  SServiceInstallFailed = 'Le service "%s" a échoué pendant son installation avec l'#39'erreur : "%s"';
  SServiceUninstallOK = 'Service désinstallé avec succès';
  SServiceUninstallFailed = 'Le service "%s" a échoué pendant sa désinstallation avec l'#39'erreur : "%s"';

  SDockedCtlNeedsName = 'Le composant ancré doit avoir un nom';
  SDockTreeRemoveError = 'Erreur à la suppression du contrôle de l'#39'arbre ancré';
  SDockZoneNotFound = ' - Zone d'#39'ancrage non trouvée';
  SDockZoneHasNoCtl = ' - La zone d'#39'ancrage n'#39'a pas de contrôle';
  SDockZoneVersionConflict = 'Erreur de chargement de la zone d'#39'ancrage à partir du flux. Version %d attendue, mais %d trouvée.';

  SAllCommands = 'Toutes les commandes';

  SDuplicateItem = 'La liste n'#39'autorise pas les doublons ($0%x)';

  STextNotFound = 'Texte non trouvé : "%s"';
  SBrowserExecError = 'Aucun navigateur par défaut n'#39'a été spécifié';

  SColorBoxCustomCaption = 'Personnaliser...';

  SMultiSelectRequired = 'Le mode multisélection doit être activé pour cette fonction.';

  SPromptArrayTooShort = 'La longueur du tableau de valeurs doit être >= à la longueur du tableau d'#39'invites';
  SPromptArrayEmpty = 'Le tableau d'#39'invites ne doit pas être vide';

  SUsername = '&Nom d'#39'utilisateur';
  SPassword = '&Mot de passe';
  SDomain = '&Domaine';
  SLogin = 'Connexion';

  SKeyCaption = 'Clé';
  SValueCaption = 'Valeur';
  SKeyConflict = 'Une clé nommée "%s" existe déjà';
  SKeyNotFound = 'Clé "%s" introuvable';
  SNoColumnMoving = 'goColMoving n'#39'est pas une option prise en charge.';
  SNoEqualsInKey = 'La clé ne doit pas contenir de signe égal ("=")';

  SSendError = 'Erreur à l'#39'envoi du courrier';
  SAssignSubItemError = 'Impossible d'#39'affecter un sous-élément à une barre d'#39'actions lorsque l'#39'un de ses parents est déjà affecté à une barre d'#39'actions';
  SDeleteItemWithSubItems = 'L'#39'élément %s comporte des sous-éléments ; le supprimer quand même ?';
  SDeleteNotAllowed = 'Vous n'#39'êtes pas autorisé à supprimer cet élément';
  SMoveNotAllowed = 'Le déplacement de l'#39'élément %s n'#39'est pas autorisé';    
  SMoreButtons = 'Boutons supplémentaires';
  SErrorDownloadingURL = 'Erreur de téléchargement de l'#39'URL : %s';
  SUrlMonDllMissing = 'Impossible de charger %s';
  SAllActions = '(Toutes les actions)';
  SNoCategory = '(pas de catégorie)';
  SExpand = 'Etendre';
  SErrorSettingPath = 'Erreur de définition du chemin : "%s"';
  SLBPutError = 'Tentative de placement des éléments dans une zone de liste de styles virtuelle';
  SErrorLoadingFile = 'Erreur lors du chargement du fichier de paramètres précédemment enregistré : %s'#13'Souhaitez-vous le supprimer ?';
  SResetUsageData = 'Réinitialiser toutes les données d'#39'utilisation ?';
  SFileRunDialogTitle = 'Exécuter';
  SNoName = '(pas de nom)';      
  SErrorActionManagerNotAssigned = 'ActionManager doit être affecté en premier lieu.';
  SAddRemoveButtons = '&Ajouter ou supprimer des boutons';
  SResetActionToolBar = 'Réinitialiser la barre d'#39'outils';
  SCustomize = '&Personnaliser...';
  SSeparator = 'Séparateur';
  SCircularReferencesNotAllowed = 'Les références circulaires ne sont pas autorisées.';
  SCannotHideActionBand = '%s ne permet pas la dissimulation';
  SErrorSettingCount = 'Erreur lors de la définition de la valeur %s.Count';
  SListBoxMustBeVirtual = 'Le style de la boîte de liste (%s) doit être virtuel afin de pouvoir définir la valeur Count';
  SUnableToSaveSettings = 'Impossible de sauvegarder les paramètres';
  SRestoreDefaultSchedule = 'Voulez-vous réinitialiser au planning de priorité par défaut ?';
  SNoGetItemEventHandler = 'Gestionnaire d'#39'événement OnGetItem non affecté';
  SInvalidColorMap = 'Colormap incorrect. Ce composant ActionBand requiert des ColorMaps de type TCustomActionBarColorMapEx';
  SDuplicateActionBarStyleName = 'Un style nommé %s a déjà été recensé';
  SMissingActionBarStyleName = 'Un style nommé %s n'#39'a pas été enregistré';
  SStandardStyleActionBars = 'Style Standard';
  SXPStyleActionBars = 'Style XP';
  SActionBarStyleMissing = 'Pas d'#39'unité de style ActionBand présente dans la clause uses.'#13'Votre application doit inclure XPStyleActnCtrls, StdStyleActnCtrls ou une unité de style ActionBand tiers dans sa clause uses';
  sParameterCannotBeNil = 'Le paramètre %s de l'#39'appel à %s ne peut être nil';
  SInvalidColorString = 'Chaîne Color incorrecte';
  SActionManagerNotAssigned = 'La propriété ActionManager %s n'#39'a pas été affectée';

  SInvalidPath = '"%s" est un chemin incorrect';
  SInvalidPathCaption = 'Chemin incorrect';

  SANSIEncoding = 'ANSI';
  SASCIIEncoding = 'ASCII';
  SUnicodeEncoding = 'Unicode';
  SBigEndianEncoding = 'Big Endian Unicode';
  SUTF8Encoding = 'UTF-8';
  SUTF7Encoding = 'UTF-7';
  SEncodingLabel = 'Encodage :';

  sCannotAddFixedSize = 'Impossible d'#39'ajouter des colonnes ou des lignes alors que le style de développement est taille fixe';
  sInvalidSpan = #39'%d'#39' n'#39'est pas une étendue correcte';
  sInvalidRowIndex = 'Indice de ligne, %d, hors limites';
  sInvalidColumnIndex = 'Indice de colonne, %d, hors limites';
  sInvalidControlItem = 'Impossible de définir ControlItem.Control en GridPanel propriétaire';
  sCannotDeleteColumn = 'Impossible de supprimer une colonne contenant des contrôles';
  sCannotDeleteRow = 'Impossible de supprimer une ligne contenant des contrôles';
  sCellMember = 'Membre';
  sCellSizeType = 'Type de taille';
  sCellValue = 'Valeur';
  sCellAutoSize = 'Automatique';
  sCellPercentSize = 'Pourcentage';
  sCellAbsoluteSize = 'Absolu';
  sCellColumn = 'Column%d';
  sCellRow = 'Row%d';

  STrayIconRemoveError = 'Impossible de supprimer l'#39'icône de notification de shell';
  STrayIconCreateError = 'Impossible de créer l'#39'icône de notification de shell';

  SPageControlNotSet = 'PageControl doit être affecté en premier lieu';

  SWindowsVistaRequired = '%s nécessite Windows Vista ou supérieur';
  SXPThemesRequired = '%s nécessite l'#39'activation de thèmes';

  STaskDlgButtonCaption = 'Button%d';
  STaskDlgRadioButtonCaption = 'RadioButton%d';
  SInvalidTaskDlgButtonCaption = 'Caption ne peut pas être vide';

  SInvalidCategoryPanelParent = 'CategoryPanel doit avoir un CategoryPanelGroup comme parent';
  SInvalidCategoryPanelGroupChild = 'Seul CategoryPanels peut être inséré dans un CategoryPanelGroup';

  SInvalidCanvasOperation = 'Opération de canevas non valide';
  SNoOwner = '%s n'#39'a pas de propriétaire';
  SRequireSameOwner = 'La source et la destination nécessitent le même propriétaire';
  SDirect2DInvalidOwner = '%s ne peut pas appartenir à un canevas différent';
  SDirect2DInvalidSolidBrush = 'Ce n'#39'est pas un pinceau de couleur unie';
  SDirect2DInvalidBrushStyle = 'Style du pinceau non valide';

  SKeyboardLocaleInfo = 'Erreur de récupération des informations locales';
  SKeyboardLangChange = 'Echec du changement de la langue d'#39'entrée';

  SOnlyWinControls = 'La tabulation ne peut s'#39'appliquer qu'#39'aux contrôles TWinControl ancrés';

  SNoKeyword = 'Aucun mot clé d'#39'aide spécifié.';

  SStyleLoadError = 'Impossible de charger le style '#39'%s'#39;
  SStyleLoadErrors = 'Impossible de charger les styles : %s';
  SStyleRegisterError = 'Style '#39'%s'#39' déjà recensé';
  SStyleClassRegisterError = 'Classe '#39'%s'#39' de style déjà recensée';
  SStyleNotFound = 'Style '#39'%s'#39' non trouvé';
  SStyleClassNotFound = 'Classe '#39'%s'#39' de style non trouvée';
  SStyleInvalidHandle = 'Handle de style non valide';
  SStyleFormatError = 'Format de style non valide';
  SStyleFileDescription = 'Fichier de style VCL';
  SStyleHookClassRegistered = 'La classe '#39'%s'#39' est déjà enregistrée pour '#39'%s'#39;
  SStyleHookClassNotRegistered = 'La classe '#39'%s'#39' n'#39'est pas enregistrée pour '#39'%s'#39;
  SStyleInvalidParameter = 'Le paramètre %s ne peut pas contenir nil';
  SStyleHookClassNotFound = 'Une classe StyleHook n'#39'a pas été enregistrée pour %s';
  SStyleFeatureNotSupported = 'Fonctionnalité non supportée par ce style';
  SStyleNotRegistered = 'Le style '#39'%s'#39' n'#39'est pas recensé';
  SStyleUnregisterError = 'Impossible de dérecenser le style système';
  SStyleNotRegisteredNoName = 'Style non recensé';


  // ColorToPrettyName strings
  SNameBlack = 'Noir';
  SNameMaroon = 'Marron';
  SNameGreen = 'Vert';
  SNameOlive = 'Olive';
  SNameNavy = 'Bleu marine';
  SNamePurple = 'Violet';
  SNameTeal = 'Sarcelle';
  SNameGray = 'Gris';
  SNameSilver = 'Argent';
  SNameRed = 'Rouge';
  SNameLime = 'Citron';
  SNameYellow = 'Jaune';
  SNameBlue = 'Bleu';
  SNameFuchsia = 'Fuchsia';
  SNameAqua = 'Aqua';
  SNameWhite = 'Blanc';
  SNameMoneyGreen = 'Vert foncé';
  SNameSkyBlue = 'Bleu ciel';
  SNameCream = 'Crème';
  SNameMedGray = 'Gris moyen';
  SNameActiveBorder = 'Bordure active';
  SNameActiveCaption = 'Libellé actif';
  SNameAppWorkSpace = 'Espace de travail de l'#39'application';
  SNameBackground = 'Fond';
  SNameBtnFace = 'Face de bouton';
  SNameBtnHighlight = 'Surbrillance de bouton';
  SNameBtnShadow = 'Ombre de bouton';
  SNameBtnText = 'Texte de bouton';
  SNameCaptionText = 'Texte de libellé';
  SNameDefault = 'Par défaut';
  SNameGradientActiveCaption = 'Libellé actif en dégradé';
  SNameGradientInactiveCaption = 'Libellé inactif en dégradé';
  SNameGrayText = 'Texte gris';
  SNameHighlight = 'Fond de surbrillance';
  SNameHighlightText = 'Texte de surbrillance';
  SNameHotLight = 'Sélectionné';
  SNameInactiveBorder = 'Bordure inactive';
  SNameInactiveCaption = 'Libellé inactif';
  SNameInactiveCaptionText = 'Texte de libellé inactif';
  SNameInfoBk = 'Fond d'#39'information';
  SNameInfoText = 'Texte d'#39'info';
  SNameMenu = 'Fond de menu';
  SNameMenuBar = 'Barre de menus';
  SNameMenuHighlight = 'Surbrillance de menu';
  SNameMenuText = 'Texte de menu';
  SNameNone = 'Aucun';
  SNameScrollBar = 'Barre de défilement';
  SName3DDkShadow = 'Ombre foncée 3D';
  SName3DLight = '3D clair';
  SNameWindow = 'Fond de fenêtre';
  SNameWindowFrame = 'Cadre de fenêtre';
  SNameWindowText = 'Texte de fenêtre';

  SInvalidBitmapPixelFormat = 'Format de pixel de bitmap incorrect, cela devrait être une image 32 bits';
  SJumplistsItemErrorGetpsi = 'Interrogation de l'#39'interface IPropertyStore';
  SJumplistsItemErrorInitializepropvar = 'Initialisation d'#39'une propriété de composant';
  SJumplistsItemErrorSetps = 'Définition de la valeur d'#39'une bibliothèque de propriétés';
  SJumplistsItemErrorCommitps = 'Validation d'#39'une bibliothèque de propriétés';
  SJumplistsItemErrorSettingarguments = 'Définition des arguments d'#39'un élément de liste de raccourcis';
  SJumplistsItemErrorSettingpath = 'Définition du chemin d'#39'un élément de liste de raccourcis';
  SJumplistsItemErrorSettingicon = 'Définition de l'#39'emplacement de l'#39'icône d'#39'un élément de liste de raccourcis';
  SJumplistsItemErrorAddingtobjarr = 'Ajout d'#39'un élément à un tableau d'#39'objets';
  SJumplistsItemErrorGettingobjarr = 'Interrogation de l'#39'interface IObjectArray';
  SJumplistsItemErrorNofriendlyname = 'La propriété FriendlyName d'#39'un élément ne doit pas être vide';
  SJumplistsItemException = 'Exception JumpListItem : Erreur %d : %s';
  SJumplistException = 'Exception de la liste des raccourcis (JumpList) : Erreur %d : %s';
  SJumplistErrorBeginlist = 'Initialisation d'#39'une nouvelle session de construction pour une nouvelle liste de raccourcis';
  SJumplistErrorAppendrc = 'Ajout d'#39'un élément à la catégorie des fichiers récents d'#39'une nouvelle liste de raccourcis';
  SJumplistErrorAppendfc = 'Ajout d'#39'un élément à la catégorie des fichiers fréquents d'#39'une nouvelle liste de raccourcis';
  SJumplistErrorAddusertasks = 'Ajout de vos tâches à une nouvelle liste de raccourcis';
  SJumplistErrorAddcategory = 'Ajout d'#39'une catégorie personnalisée ('#39'%s'#39') et de ses éléments enfant à une nouvelle liste de raccourcis';
  SJumplistErrorCommitlist = 'Validation d'#39'une nouvelle liste de raccourcis';
  SJumplistExceptionInvalidOS = 'Le système d'#39'exploitation en cours ne prend pas en charge les listes de raccourcis';
  SJumplistExceptionAppID = 'Le processus en cours a déjà un ID d'#39'application : %s';

  { BeginInvoke }

  sBeginInvokeNoHandle = 'Impossible d'#39'appeler BeginInvoke sur un contrôle sans parent ni handle de fenêtre';

  SToggleSwitchCaptionOn = 'Activé';
  SToggleSwitchCaptionOff = 'Désactivé';
  SInvalidRelativePanelControlItem = 'Impossible de définir ControlItem.Control sur le RelativePanel propriétaire';
  SInvalidRelativePanelSibling = 'Le contrôle n'#39'est pas un frère dans RelativePanel';
  SInvalidRelativePanelSiblingSelf = 'Le contrôle ne peut pas être positionné relativement à lui-même';
  SRelativePanelCircularDependency = 'Erreur RelativePanel : dépendance circulaire détectée. La disposition n'#39'est pas terminée';

implementation

end.
