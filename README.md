# MARC-to-JSON

Haskell parser from MARC record format to JSON

# Intro

MARC (MAchine-Readable Cataloging) standards are a set of digital formats for the description of items cataloged by libraries, such as books. American computer scientist Henriette Avram developed MARC in the 1960s to create records that could be read by computers and shared among libraries. About a decade later it became the international standard.

# Formats supported

The program currently supports 5 different MARC formats, including MARC 21 which is the standard in the USA and Canada, and two types of UNIMARC formatting that is mainly used across Europe.

You can see examples of supported formats in the `marc_examples` folder.


# Run Program

The program expects the following data to run:

```
:main /path/to/marc_file.txt /path/to/output_file.json
```

# Variables

If you need to introduce a new type of leader starting string you can add a new `string` to the `leaderStartStrings` array.

To add a new field identification `char` append the `fieldIdChars` array.

To add a new subfield starting separator `char` append the `subfieldStartChars` array.

All are located at the top of the file.

# Example

Parsing the following MARC 21 file:

```
LDR 01142cam**2200301*a*4500
001 92005291
003 DLC
005 19930521155141.9
008 920219s1993 caua j 000 0 eng
010 ## $a92005291
020 ## $a0152038655 :$c$15.95
040 ## $aDLC$cDLC$dDLC
042 ## $alcac
050 00 $aPS3537.A618$bA88 1993
082 00 $220$a811/.52
100 1# $aSandburg, Carl,$d1878-1967.
245 10 $aArithmetic /$cCarl Sandburg ; illustrated as an anamorphic adventure by Ted Rand.
250 ## $a1st ed.
260 ## $aSan Diego :$bHarcourt Brace Jovanovich,$cc1993.
300 ## $a1 v. (unpaged) :$bill. (some col.) ;$c26 cm.
500 ## $aOne Mylar sheet included in pocket.
520 ## $aA poem about numbers and their characteristics. Features anamorphic, or distorted, drawings which can be restored to normal by viewing from a particular angle or by viewing the image's reflection in the provided Mylar cone.
650 #0 $aArithmetic$xJuvenile poetry.
650 #0 $aChildren's poetry, American.
650 #1 $aArithmetic$xPoetry.
650 #1 $aAmerican poetry.
650 #1 $aVisual perception.
700 1# $aRand, Ted,$eill.
```

Will give us the following JSON as a result:

```
{
"leader": "01142cam**2200301*a*4500",
"fields":
[
	{
		"001": "92005291"
	},
 	{
		"003": "DLC"
	},
 	{
		"005": "19930521155141.9"
	},
 	{
		"008": "920219s1993 caua j 000 0 eng"
	},
	{
		"010": {
			"subfields":
			[
				{
					"a":"92005291"
				}, 
			],
			"ind1":"#",
			"ind2":"#"
		}
	},
 	{
		"020": {
			"subfields":
			[
				{
					"a":"0152038655 :"
				}, 
				{
					"c":""
				}, 
				{
					"1":"5.95"
				}, 
			],
			"ind1":"#",
			"ind2":"#"
		}
	},
 	{
		"040": {
			"subfields":
			[
				{
					"a":"DLC"
				}, 
				{
					"c":"DLC"
				}, 
				{
					"d":"DLC"
				}, 
			],
			"ind1":"#",
			"ind2":"#"
		}
	},
 	{
		"042": {
			"subfields":
			[
				{
					"a":"lcac"
				}, 
			],
			"ind1":"#",
			"ind2":"#"
		}
	},
 	{
		"050": {
			"subfields":
			[
				{
					"a":"PS3537.A618"
				}, 
				{
					"b":"A88 1993"
				}, 
			],
			"ind1":"0",
			"ind2":"0"
		}
	},
 	{
		"082": {
			"subfields":
			[
				{
					"2":"20"
				}, 
				{
					"a":"811/.52"
				}, 
			],
			"ind1":"0",
			"ind2":"0"
		}
	},
 	{
		"100": {
			"subfields":
			[
				{
					"a":"Sandburg, Carl,"
				}, 
				{
					"d":"1878-1967."
				}, 
			],
			"ind1":"1",
			"ind2":"#"
		}
	},
 	{
		"245": {
			"subfields":
			[
				{
					"a":"Arithmetic /"
				}, 
				{
					"c":"Carl Sandburg ; illustrated as an anamorphic adventure by Ted Rand."
				}, 
			],
			"ind1":"1",
			"ind2":"0"
		}
	},
 	{
		"250": {
			"subfields":
			[
				{
					"a":"1st ed."
				}, 
			],
			"ind1":"#",
			"ind2":"#"
		}
	},
 	{
		"260": {
			"subfields":
			[
				{
					"a":"San Diego :"
				}, 
				{
					"b":"Harcourt Brace Jovanovich,"
				}, 
				{
					"c":"c1993."
				}, 
			],
			"ind1":"#",
			"ind2":"#"
		}
	},
 	{
		"300": {
			"subfields":
			[
				{
					"a":"1 v. (unpaged) :"
				}, 
				{
					"b":"ill. (some col.) ;"
				}, 
				{
					"c":"26 cm."
				}, 
			],
			"ind1":"#",
			"ind2":"#"
		}
	},
 	{
		"500": {
			"subfields":
			[
				{
					"a":"One Mylar sheet included in pocket."
				}, 
			],
			"ind1":"#",
			"ind2":"#"
		}
	},
 	{
		"520": {
			"subfields":
			[
				{
					"a":"A poem about numbers and their characteristics. Features anamorphic, or distorted, drawings which can be restored to normal by viewing from a particular angle or by viewing the image's reflection in the provided Mylar cone."
				}, 
			],
			"ind1":"#",
			"ind2":"#"
		}
	},
 	{
		"650": {
			"subfields":
			[
				{
					"a":"Arithmetic"
				}, 
				{
					"x":"Juvenile poetry."
				}, 
			],
			"ind1":"#",
			"ind2":"0"
		}
	},
 	{
		"650": {
			"subfields":
			[
				{
					"a":"Children's poetry, American."
				}, 
			],
			"ind1":"#",
			"ind2":"0"
		}
	},
 	{
		"650": {
			"subfields":
			[
				{
					"a":"Arithmetic"
				}, 
				{
					"x":"Poetry."
				}, 
			],
			"ind1":"#",
			"ind2":"1"
		}
	},
 	{
		"650": {
			"subfields":
			[
				{
					"a":"American poetry."
				}, 
			],
			"ind1":"#",
			"ind2":"1"
		}
	},
 	{
		"650": {
			"subfields":
			[
				{
					"a":"Visual perception."
				}, 
			],
			"ind1":"#",
			"ind2":"1"
		}
	},
 	{
		"700": {
			"subfields":
			[
				{
					"a":"Rand, Ted,"
				}, 
				{
					"e":"ill."
				}, 
			],
			"ind1":"1",
			"ind2":"#"
		}
	},
]
}
```

The leader field, control fields and fields with subfields are all separated into individual objects.
