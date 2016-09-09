// Fonts and Text Formats used in the lab companion

// Font objects
var ExtraBoldFontClass:Class = getDefinitionByName ("ProximaNova_EB") as Class;
var ExtraBold_fnt:Font = new ExtraBoldFontClass () as Font;

var BoldFontClass:Class = getDefinitionByName ("ProximaNova_B") as Class;
var Bold_fnt:Font = new BoldFontClass () as Font;

var RegularFontClass:Class = getDefinitionByName ("ProximaNova_R") as Class;
var Regular_fnt:Font = new RegularFontClass () as Font;

// Textformat objects
// Title screen
var titleLogo1_fmt:TextFormat = new TextFormat();
var titleLogo2_fmt:TextFormat = new TextFormat();
var title1_fmt:TextFormat = new TextFormat();
var title2_fmt:TextFormat = new TextFormat();
var titleBeginButton_fmt:TextFormat = new TextFormat();

titleLogo1_fmt.font = Regular_fnt.fontName;
titleLogo1_fmt.color = 0x3e857d;
titleLogo1_fmt.size = 39;

titleLogo2_fmt.font = ExtraBold_fnt.fontName;
titleLogo2_fmt.color = 0xffa200;
titleLogo2_fmt.size = 42.56;

title1_fmt.font = ExtraBold_fnt.fontName;
title1_fmt.color = 0xe6e6e6;
title1_fmt.size = 150;
title1_fmt.align = "center";

title2_fmt.font = ExtraBold_fnt.fontName;
title2_fmt.color = 0x3e857d;
title2_fmt.size = 150;
title2_fmt.align = "center";

titleBeginButton_fmt.font = Bold_fnt.fontName;
titleBeginButton_fmt.color = 0xffffff;
titleBeginButton_fmt.size = 43;
titleBeginButton_fmt.align = "center";

// Intro screen
var introStaticTitle_fmt:TextFormat = new TextFormat();
var introDynamicTitle_fmt:TextFormat = new TextFormat();
var introImageDescription_fmt:TextFormat = new TextFormat();

introStaticTitle_fmt.font = Bold_fnt.fontName;
introStaticTitle_fmt.color = 0x3e857d;
introStaticTitle_fmt.size = 60;
introStaticTitle_fmt.kerning = true;
introStaticTitle_fmt.letterSpacing = .15;

introDynamicTitle_fmt.font = Bold_fnt.fontName;
introDynamicTitle_fmt.color = 0xffa200;
introDynamicTitle_fmt.size = 60;
introDynamicTitle_fmt.kerning = true;
introDynamicTitle_fmt.letterSpacing = .15;

introImageDescription_fmt.font = Regular_fnt.fontName;
introImageDescription_fmt.color = 0x000000;
introImageDescription_fmt.size = 18;
introImageDescription_fmt.kerning = true;
introImageDescription_fmt.letterSpacing = .25;
introImageDescription_fmt.align = "left";

// Select screen
var selectInstruction_fmt:TextFormat = new TextFormat();

selectInstruction_fmt.font = Bold_fnt.fontName;
selectInstruction_fmt.color = 0x777777;
selectInstruction_fmt.size = 60;

// Experiment screen
var experimentTitle_fmt:TextFormat = new TextFormat();
var experimentStep_fmt:TextFormat = new TextFormat();
var experimentStepCount_fmt:TextFormat = new TextFormat();
var experimentExplanationHeader_fmt:TextFormat = new TextFormat();
var experimentExplanation_fmt:TextFormat = new TextFormat();
var explainerExplanationHeader_fmt:TextFormat = new TextFormat();
var explainerExplanation_fmt:TextFormat = new TextFormat();
var experimentExplainerHeader_fmt:TextFormat = new TextFormat();
var experimentExplainer_fmt:TextFormat = new TextFormat();

experimentTitle_fmt.font = Bold_fnt.fontName;
experimentTitle_fmt.color = 0xffa200;
experimentTitle_fmt.size = 60;
experimentTitle_fmt.kerning = true;
experimentTitle_fmt.letterSpacing = .25;

experimentStep_fmt.font = Regular_fnt.fontName;
experimentStep_fmt.color = 0x000000;
experimentStep_fmt.size = 18;
experimentStep_fmt.align = "left";

experimentStepCount_fmt.font = Regular_fnt.fontName;
experimentStepCount_fmt.color = 0x000000;
experimentStepCount_fmt.size = 16;
experimentStepCount_fmt.kerning = true;
experimentStepCount_fmt.letterSpacing = 1.75;
experimentStepCount_fmt.align = "center";

experimentExplainerHeader_fmt.font = Bold_fnt.fontName;
experimentExplainerHeader_fmt.color = 0x3e857d;
experimentExplainerHeader_fmt.size = 30;

experimentExplainer_fmt.font = Regular_fnt.fontName;
experimentExplainer_fmt.color = 0x231f20;
experimentExplainer_fmt.size = 18;
experimentExplainer_fmt.leading = 4;

// Glossary
var glossaryTab_fmt:TextFormat = new TextFormat();
var glossaryTermSelected_fmt:TextFormat = new TextFormat();
var glossaryTermUnselected_fmt:TextFormat = new TextFormat();
var glossaryTermName_fmt:TextFormat = new TextFormat ();
var glossaryTermDescription_fmt:TextFormat = new TextFormat ();
var glossaryPreviousPage_fmt:TextFormat = new TextFormat ();
var glossaryNextPage_fmt:TextFormat = new TextFormat ();
var glossaryCloseTab_fmt:TextFormat = new TextFormat ();

glossaryTab_fmt.font = Regular_fnt.fontName;
glossaryTab_fmt.color = 0xFFFFFF;
glossaryTab_fmt.size = 26;
glossaryTab_fmt.kerning = true;
glossaryTab_fmt.letterSpacing = 1.5;
glossaryTab_fmt.align = "center";

glossaryTermUnselected_fmt.font = Regular_fnt.fontName;
glossaryTermUnselected_fmt.color = 0xffffff;
glossaryTermUnselected_fmt.size = 28;

glossaryTermSelected_fmt.font = Bold_fnt.fontName;
glossaryTermSelected_fmt.color = 0xffa200;
glossaryTermSelected_fmt.size = 28;

glossaryTermName_fmt.font = Bold_fnt.fontName;
glossaryTermName_fmt.color = 0x4d4d4d;
glossaryTermName_fmt.size = 54;

glossaryTermDescription_fmt.font = Regular_fnt.fontName;
glossaryTermDescription_fmt.color = 0xFFFFFF;
glossaryTermDescription_fmt.size = 24;
glossaryTermDescription_fmt.leading = 8;

glossaryPreviousPage_fmt.font = Regular_fnt.fontName;
glossaryPreviousPage_fmt.color = 0x4d4d4d;
glossaryPreviousPage_fmt.size = 28;
glossaryPreviousPage_fmt.kerning = true;
glossaryPreviousPage_fmt.letterSpacing = 1.5;
glossaryPreviousPage_fmt.align = "left";

glossaryNextPage_fmt.font = Regular_fnt.fontName;
glossaryNextPage_fmt.color = 0x4d4d4d;
glossaryNextPage_fmt.size = 28;
glossaryNextPage_fmt.kerning = true;
glossaryNextPage_fmt.letterSpacing = 1.5;
glossaryNextPage_fmt.align = "right";

glossaryCloseTab_fmt.font = Regular_fnt.fontName;
glossaryCloseTab_fmt.color = 0x4d4d4d;
glossaryCloseTab_fmt.size = 28;
glossaryCloseTab_fmt.kerning = true;
glossaryCloseTab_fmt.letterSpacing = 1.5;
glossaryCloseTab_fmt.align = "left";

// Navigation
var navigationButton_fmt:TextFormat = new TextFormat();

navigationButton_fmt.font = Regular_fnt.fontName;
navigationButton_fmt.color = 0xFFFFFF;
navigationButton_fmt.size = 28;
navigationButton_fmt.kerning = true;
navigationButton_fmt.letterSpacing = 1.5;
navigationButton_fmt.align = "center";