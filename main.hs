import Text.Parsec
import System.Environment


leaderStartStrings :: [String]
leaderStartStrings = ["LEADER", "LDR", "000"]


subfieldStartChars :: [Char]
subfieldStartChars = ['$', '|']


fieldIdChars :: [Char]
fieldIdChars = ['#', '_']


type LeaderData = String
type ControlID = String
type ControlData = String
type FieldID = String
type FieldIndent = String
type SubfieldID = Char
type SubfieldData = String


data Marc = Marc21 Leader Controls FieldList | Unimarc FieldList

data Leader = Leader LeaderData

data Controls = Controls [Control]

data Control = Control ControlID ControlData

data FieldList = FieldList [Field]

data Field = Field FieldID FieldIndent [SubField]

data SubField = NormalSubField SubfieldID SubfieldData | NoIdSubField SubfieldData

instance Show Marc where 
    show (Marc21 ldr cnts fields) = "{\n\"leader\": " ++ show ldr ++ ",\n\"fields\":\n[\n" ++ show cnts ++ show fields ++ "]\n}"
    show (Unimarc fields) = "{\n\"fields\":\n[\n" ++ show fields ++ "]\n}"
    
instance Show Leader where 
    show (Leader ldr) = show ldr
    
instance Show Controls where 
    show (Controls cont) = unwords . map show $ cont
    
instance Show Control where 
    show (Control ctrlid val) = "\t{\n\t\t\"00" ++ id ctrlid ++ "\": " ++ show val ++ "\n\t},\n"

instance Show FieldList where
    show (FieldList fields) = unwords . map show $ fields

instance Show Field where
    show (Field field_id id subfld) = "\t{\n\t\t\"" ++ field_id ++ "\": {\n\t\t\t\"subfields\":\n\t\t\t[" ++ showSubFld subfld ++ "\n\t\t\t],\n\t\t\t\"ind1\":" ++ showIdOne id ++ ",\n\t\t\t\"ind2\":" ++ showIdTwo id ++ "\n\t\t}\n\t},\n"
        where showSubFld [] = ""
              showSubFld (x:xs) = show x ++ ", " ++ showSubFld xs
              showIdOne [] = "\"\""
              showIdOne [x] = "\"" ++ [x] ++ "\""
              showIdOne (x:xs) = "\"" ++ [x] ++ "\""
              showIdTwo [] = "\"\""
              showIdTwo x = "\"" ++ [last x] ++ "\""

instance Show SubField where
    show (NormalSubField subfld name) = "\n\t\t\t\t{\n\t\t\t\t\t\"" ++ [subfld] ++ "\":\"" ++ name ++ "\"\n\t\t\t\t}"
    show (NoIdSubField name) = "\n\t\t\t\t\"" ++ name ++ "\""


breakOn :: String 
breakOn = subfieldStartChars ++ "\US\RS\n"


breakOnUnimarc :: String 
breakOnUnimarc = "[\n"


oneOfStrings :: [String] -> Parsec String Int String
oneOfStrings = foldl (\a s -> a <|> try (string s)) (fail "")


oneOfChars :: [Char] -> Parsec String Int Char
oneOfChars = foldl (\a c -> a <|> try (char c)) (oneOf "")


subfield :: Parsec String Int SubField
subfield = do
    oneOfChars subfieldStartChars
    subfld <- alphaNum
    optional space
    name <- many (noneOf breakOn)
    return (NormalSubField subfld name)


subfieldUnimarc :: Parsec String Int SubField
subfieldUnimarc = do 
    subfld <-  between (char '[') (char ']') alphaNum
    name <- many (noneOf breakOnUnimarc)
    return (NormalSubField subfld name)


field :: Parsec String Int Field
field = do
    field_id <- count 3 digit
    optional space
    id <- many (digit <|> oneOfChars fieldIdChars)
    optional space
    subfld <- (try (many1 subfield)) <|> (try (many1 subfieldUnimarc))
    optional newline
    return (Field field_id id subfld)


specialUnimarcSubfield :: Parsec String Int SubField 
specialUnimarcSubfield = do 
    char '\US'
    name <- many (noneOf breakOn)
    return (NoIdSubField name)
    
    
fieldSpecialChars :: Parsec String Int Field
fieldSpecialChars = do 
    field_id <- count 3 digit
    id <- count 2 (digit <|> char ' ')
    subfld <- many1 specialUnimarcSubfield
    char '\RS'
    return (Field field_id id subfld)
    
    
fields :: Parsec String Int FieldList
fields = do 
    flds <- (try (many1 field)) <|> (try (many1 fieldSpecialChars))
    return (FieldList flds)


leader :: Parsec String Int Leader
leader = do
    oneOfStrings leaderStartStrings
    optional space
    ldr <- manyTill anyChar (try newline)
    return (Leader ldr)


control :: Parsec String Int Control
control = do 
    string "00"
    id <- digit
    optional space 
    cnt <- manyTill anyChar (try newline)
    return (Control [id] cnt)
  
    
controls :: Parsec String Int Controls 
controls = do
    cnts <- many1 (try control)
    return (Controls cnts)


marc21 :: Parsec String Int Marc
marc21 = do
    ldr <- leader
    cnts <- controls
    flds <- fields
    return (Marc21 ldr cnts flds)
    
    
unimarc :: Parsec String Int Marc
unimarc = do 
    flds <- fields
    return (Unimarc flds)
    

document :: Parsec String Int Marc
document = do
    marc <- (try marc21) <|> (try unimarc)
    return marc


main :: IO ()
main = do (input:output:[]) <- getArgs
          cont <- readFile input
          case (runParser document 0 input cont) of
            Left err -> putStrLn . show $ err
            Right marc -> writeFile output . show $ marc