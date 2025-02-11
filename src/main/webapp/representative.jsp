<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
         pageEncoding="ISO-8859-1"%>
<%@page import="java.sql.*" %>

<%

    Connection con = null;

    try
    {
        Class.forName("org.mariadb.cj.jdbc.Driver");
    }
    catch(ClassNotFoundException e)
    {
        e.printStackTrace();
    }
    try
    {
        con=DriverManager.getConnection("jdbc:mariadb://localhost:3306/edms" , "root","");
    }
    catch(SQLException e)
    {
        e.printStackTrace();
    }

%>

<!DOCTYPE html>
<html>
<head>
    <title>Emergency Disaster Management System</title>
    <link rel="stylesheet" href="CSS/Profile.css" />
    <!-- Tailwind CDN -->
    <script src="https://cdn.tailwindcss.com"></script>
    <!-- DaisyUI CDN -->
    <link
            href="https://cdn.jsdelivr.net/npm/daisyui@3.7.3/dist/full.css"
            rel="stylesheet"
            type="text/css"
    />
    <!-- Animate.css CDN -->
    <link
            rel="stylesheet"
            href="https://cdnjs.cloudflare.com/ajax/libs/animate.css/4.1.1/animate.min.css"
    />
    <!-- AOS CDN -->
    <link rel="stylesheet" href="https://unpkg.com/aos@next/dist/aos.css" />
    <!-- Font Awesome -->
    <script
            src="https://kit.fontawesome.com/f13afb77f1.js"
            crossorigin="anonymous"
    ></script>
    <style>
        /* Flower Border Pattern with Custom Color */
        .flower-border {
            position: relative;
            padding: 2rem;
            background-color: white;
            border-radius: 16px;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
            overflow: hidden;
            border: 8px solid transparent; /* Making space for the border */
            border-image: url('https://www.svgrepo.com/show/281107/flower-pattern-border.svg') 30 stretch; /* Custom flower pattern SVG */
            background-color: #fff; /* Ensures the background is white behind the border */
            border-color: #FB923C; /* Custom border color (can be any color you prefer) */
        }

        /* Fancy border for inputs */
        .input-floral {
            border: 2px solid #fca311;
            border-radius: 8px;
            padding: 10px;
            background-color: #fefae0;
            font-size: 16px;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
            transition: all 0.3s ease-in-out;
        }

        .input-floral:focus {
            outline: none;
            border-color: #e85d04;
            box-shadow: 0 0 10px rgba(255, 165, 0, 0.7);
        }

        /* Custom button styling */
        .btn-floral {
            background-color: #fca311;
            color: white;
            border-radius: 8px;
            padding: 12px;
            font-size: 18px;
            border: none;
            width: 100%;
            cursor: pointer;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
            transition: all 0.3s ease-in-out;
        }

        .btn-floral:hover {
            background-color: #e85d04;
            box-shadow: 0 0 10px rgba(255, 165, 0, 0.7);
        }

        /* Make the form container stretch full width */
        .form-container {
            width: 100%; /* Take up full width of the screen */
            max-width: 100%; /* Disable any maximum width constraint */
            margin: 0 auto;
            padding: 40px;
            background-color: white;
            border-radius: 16px;
            box-shadow: 0 4px 10px rgba(0, 0, 0, 0.2);
            overflow: hidden;
        }

        /* Additional styling for responsiveness */
        @media (min-width: 768px) {
            .form-container {
                width: 40%; /* Optionally restrict the width on larger screens */
                max-width: 1200px; /* Maximum width on large screens */
            }
        }
    </style>
</head>



<!-- JavaScript Code -->


<script>

    var subjectObject = {

        "Kachin": {
            "Myitkyina": [
                "Myitkyina",
                "Aungmyintha",
                "Sitapu"
            ],
            "Naungmon": [
                "Naungmon",
                "Pannandin",
                "Khareng"
            ],
            "Bhamaw": [
                "Bhamaw",
                "Sinthay"
            ],
            "Chibwe": [
                "Chibwe",
                "Panwar",
                "Chipyit"
            ],
            "Ingyanyan": [
                "Ingyanyan",
                "Hkawan"
            ],
            "Khaunglanphu": [
                "Khaunglanphu",
                "Tangbau"
            ],
            "Machanbaw": [
                "Machanbaw",
                "Zarbung"
            ],
            "Mansi": [
                "Mansi",
                "Manwingyi"
            ],
            "Mogaung": [
                "Mogaung",
                "Nmtee",
                "Pinbaw",
                "Mongyang"
            ],
            "Mohnyin": [
                "Mohnyin",
                "Hopin",
                "Mawhan",
                "Nantmon",
                "Mongmao"
            ],
            "Momauk": [
                "Momauk",
                "Myothit",
                "Namhkam"
            ],
            "Phakant": [
                "Phakant",
                "Karmine",
                "Hkamti"
            ],
            "Putao": [
                "Putao",
                "Kaunghe"
            ],
            "Sawlaw": [
                "Sawlaw",
                "Kawmun"
            ],
            "Shwegu": [
                "Shwegu",
                "Sinkham",
                "Mandalin"
            ],
            "Sinbo": [
                "Sinbo",
                "Zayangyi"
            ],
            "Sunpayabom": [
                "Sunpayabom",
                "Yangyang"
            ],
            "Taning": [
                "Taning",
                "Htamanthi"
            ],
            "Waingmaw": [
                "Waingmaw",
                "Warshaung",
                "Lajayang"
            ]
        }
        ,


        "Kayah": {
            "Bawlakhe": [
                "Bawlakhe",
                "Ywa Thit"
            ],
            "Demohso": [
                "Demohso",
                "Dawtamagyi"
            ],
            "Loikaw": [
                "Loikaw",
                "Lawpita",
                "Loilenlay"
            ],
            "Meisei": [
                "Meisei"
            ],
            "Pharuso": [
                "Pharuso"
            ],
            "Phasaung": [
                "Phasaung",
                "Mawchee"
            ],
            "Shartaw": [
                "Shartaw"
            ]
        },


        "Kayin": {
            "Hlainebwe": [
                "Hlainebwe",
                "Paingkyon",
                "Shwegwan"
            ],
            "Hpaan": [
                "Hpaan",
                "Barkat",
                "Htonaing",
                "Myaingkalay",
                "Zarthapyin"
            ],
            "Hpapun": [
                "Hpapun",
                "Kamamaung"
            ],
            "Kawkareit": [
                "Kawkareit",
                "Kyondo"
            ],
            "Kyarinseikkyi": [
                "Kyarinseikkyi",
                "Kyaikdon"
            ],
            "Myawaddy": [
                "Myawaddy",
                "ThinkhabNyinaung"
            ],
            "Thantaunggyi": [
                "Thantaunggyi",
                "Thantaungthit",
                "Latetho"
            ]
        },

        "Chin": {
            "Falam": [
                "Falam",
                "Reed",
                "Loneban"
            ],
            "Hakah": [
                "Hakah",
                "Su-Khua",
                "Khonekyone"
            ],
            "Htantalan": [
                "Htantalan",
                "Thikee",
                "Faroom"
            ],
            "Kanpetlat": [
                "Kanpetlat",
                "Shinbaung"
            ],
            "Matupi": [
                "Matupi",
                "Rezwa",
                "Oakka",
                "Lailanpi"
            ],
            "Mindat": [
                "Mindat",
                "Aukchang"
            ],
            "Teetain": [
                "Teetain",
                "Htotehlaing",
                "Tweehtan",
                "Saizang",
                "Tunzan",
                "Kyeekhar"
            ]
        },

        "Mon": {
            "Beelin": [
                "Beelin",
                "Taungzon"
            ],
            "Chaungsone": [
                "Chaungsone",
                "Kalwi",
                "Muyitkalay",
                "Ywalut"
            ],
            "Kyaikhto": [
                "Kyaikhto",
                "Theinzayet",
                "Kyeikhteeyoyinpyin",
                "Kyeikkatha",
                "Mayangone",
                "Mokepalin",
                "Sittaung"
            ],
            "Kyaikmaraw": [
                "Kyaikmaraw",
                "Nyaungbinseik",
                "Chaungnagwa",
                "Tayanar"
            ],
            "Mawlamyaing": [
                "Mawlamyaing",
                "Daingwunkwin",
                "Daweizu",
                "Kadoe",
                "Mawlamyaing University",
                "Mupon",
                "Myaingthaya",
                "Zayyathiri"
            ],
            "Mudon": [
                "Mudon",
                "Hpaout",
                "Kaloutthaut",
                "Kamawet",
                "Nattaung"
            ],
            "Paung": [
                "Paung",
                "Ahhlat",
                "Kywechan",
                "Mottama",
                "Yinnyein",
                "Zinkyeik"
            ],
            "Thahton": [
                "Thahton",
                "Theinseik",
                "Thutdamawaddy"
            ],
            "Thanbyuzayet": [
                "Thanpyuzayet",
                "Kyonkadat",
                "Panga",
                "Wegali",
                "Kyaikkhame"
            ],
            "Ye": [
                "Ye",
                "Ahsin",
                "Hnitkayin",
                "Khawza",
                "Kyaungywa",
                "Lamine"
            ]
        },


        "Rakhine": {
            "Ann": [
                "Ann",
                "Tattaung"
            ],
            "Buthidaung": [
                "Buthidaung",
                "Ponnyolate",
                "Kahtila",
                "Nyanugchaung"
            ],
            "Gwa": [
                "Gwa",
                "Kyeintail",
                "Kanthaya"
            ],
            "Kyaukphyu": [
                "Kyaukphyu",
                "Zinchaung",
                "Apaukwa"
            ],
            "Mamaung": [
                "Mamaung",
                "Thitpon"
            ],
            "Maungdaw": [
                "Maungdaw",
                "Aungthapyay",
                "Kyaukpantu",
                "Mingalarnyunt"
            ],
            "Minbya": [
                "Minbya",
                "Kanni"
            ],
            "MyaukOo": [
                "MyaukOo",
                "Myaungbwe"
            ],
            "Myepon": [
                "Myepon"
            ],
            "Paletwa": [
                "Paletwa"
            ],
            "Panmyaung": [
                "Panmyaung"
            ],
            "Pauktaw": [
                "Pauktaw"
            ],
            "Ponnagyun": [
                "Ponnagyun",
                "Thetat"
            ],
            "Rambree": [
                "Rambree",
                "Kyauknimaw"
            ],
            "Rathedaung": [
                "Rathedaung",
                "Ahngumaw"
            ],
            "Sittwe": [
                "Sittwe",
                "Mingan",
                "Thatkaypyin"
            ],
            "Taunggoke": [
                "Taunggoke",
                "Ywama",
                "Lamu"
            ],
            "Thandway": [
                "Ngapali",
                "Kinmaw",
                "Pazunphay",
                "Thandway"
            ]
        },

        "Shan": {
            "Chinshwehaw": [
                "Chinshwehaw"
            ],
            "Homain": [
                "Homain"
            ],
            "Hopan": [
                "Hopan",
                "Minepauk",
                "Mineyang"
            ],
            "Hopone": [
                "Hotaung",
                "Nanttit",
                "Seloo"
            ],
            "Inndaw": [
                "Panlone"
            ],
            "Kalaw": [
                "Hopone",
                "Mankyeepin",
                "Minewa",
                "Mineyaung",
                "Mineyel"
            ],
            "Karli": [
                "Kyaukkacha"
            ],
            "Khollan": [
                "Kyauktan"
            ],
            "Khonegyan": [
                "Inndaw"
            ],
            "Konhein": [
                "Aungpan",
                "Moemate"
            ],
            "Konlon": [
                "Bawsai"
            ],
            "Kutkai": [
                "Heho",
                "Manheiro",
                "Moenae",
                "Monekoe"
            ],
            "Kyainglatt": [
                "Kalaw",
                "Muse"
            ],
            "Kyaingtaung": [
                "Myindike"
            ],
            "Kyaingtong": [
                "Monewee",
                "Sellan",
                "Wetpyuyae"
            ],
            "Kyaukme": [
                "Karli",
                "Kyarsakhan",
                "Maingyin",
                "Nankham"
            ],
            "Kyauktalone": [
                "Khollan"
            ],
            "Kyaythee": [
                "khonegyan",
                "Mansan"
            ],
            "Lashio": [
                "Bawtwin",
                "Manaung",
                "Mineseike",
                "Tarkaw"
            ],
            "Laukkaing": [
                "Konlon"
            ],
            "Linkhe": [
                "Kaungkhar"
            ],
            "Loilin": [
                "Kangyi",
                "Kutkai"
            ],
            "Mabain": [
                "Manpyain"
            ],
            "Manton": [
                "Nantphatka"
            ],
            "Maukmai": [
                "Mainglone",
                "Tamoehnye"
            ],
            "Minekai": [
                "Kyainglatt",
                "Wanpon"
            ],
            "Minelar": [
                "Kyaingtong",
                "Minelar"
            ],
            "Minemaw": [
                "Loimwe"
            ],
            "Minekhote": [
                "Kyaingtong"
            ],
            "Mineyaung": [
                "Kyainglatt",
                "Khaungtaing",
                "Kyaysargone",
                "Lashio"
            ],
            "Mineyel": [
                "Lashiogyi",
                "Maingyaw"
            ],
            "Mineyu": [
                "Mineyu"
            ],
            "Moemate": [
                "Mansanyaekya"
            ],
            "Muse": [
                "Minethouk",
                "Nanpan",
                "Nantpaung",
                "Ngaphe'chaung"
            ],
            "Namhpai": [
                "Mabain"
            ],
            "Nankham": [
                "Naungmon",
                "Sagar"
            ],
            "Nansang": [
                "Minepon"
            ],
            "Nantmatu": [
                "Linkhe",
                "Panwine"
            ],
            "Nantsan": [
                "Kharatdon"
            ],
            "Naungcho": [
                "Moebywe",
                "Phiekon",
                "Pinlaung",
                "Pinlone University",
                "Shwepyiaye"
            ],
            "Nyaungshwe": [
                "Banyin",
                "Kyone",
                "Maukmai",
                "Naungmon",
                "Pitaya",
                "Pwayhla",
                "Saikehaung",
                "Tikyit"
            ],
            "Taunggyi": [
                "Nantlan",
                "Pinphit",
                "Sinkyawt",
                "Taungni",
                "Thipaw",
                "Tonta"
            ],
            "Thipal": [
                "Bahtoo",
                "Minesatt",
                "Mineshue"
            ],
            "Yatsauk": [
                "Kaungbo",
                "Wantkan"
            ],
            "Ywarngan": [
                "Myinkyadoe",
                "YeiOo",
                "Ywarngan"
            ]
        },

        "Tanintharyi": {
            "Bokpyin": [
                "Bokpyin",
                "Pyigyimandaing"
            ],
            "Dawei": [
                "Dawei",
                "Myittha"
            ],
            "Kawthaung": [
                "Kawthaung"
            ],
            "Kyunzu": [
                "Kyunzu"
            ],
            "Launglone": [
                "Launglone",
                "Maungmagun",
                "Thakyettaw"
            ],
            "Myeik": [
                "Myeik"
            ],
            "Palaw": [
                "Palaw"
            ],
            "Tanintharyi": [
                "Tanintharyi"
            ],
            "Thayetchaung": [
                "Thayetchaung"
            ],
            "Yephyu": [
                "Yephyu",
                "Pagawzun",
                "Kanbauk"
            ]
        },

        "Sagaing": {
            "Ahyadaw": [
                "Ahyadaw"
            ],
            "Banmauk": [
                "Banmauk"
            ],
            "Budalin": [
                "Budalin"
            ],
            "Chaung U": [
                "Chaung U"
            ],
            "Depeyin": [
                "Depeyin"
            ],
            "Homalin": [
                "Homalin"
            ],
            "Indaw": [
                "Indaw",
                "Meza"
            ],
            "Kale": [
                "Kale",
                "Natchaung"
            ],
            "Kalewa": [
                "Kalewa"
            ],
            "Kani": [
                "Kani"
            ],
            "Kantbalu": [
                "Kantbalu",
                "Chatthin",
                "Htantabin",
                "HtanKone"
            ],
            "Katha": [
                "Katha",
                "Inywa"
            ],
            "Kawlin": [
                "Kawlin",
                "Koehtaungbo"
            ],
            "Kantee": [
                "Kantee"
            ],
            "Khin U": [
                "Khin U"
            ],
            "Kyunhla": [
                "Kyunhla"
            ],
            "Laheir": [
                "Laheir"
            ],
            "Layshee": [
                "Layshee"
            ],
            "Mawlaik": [
                "Mawlaik"
            ],
            "Mingin": [
                "Mingin"
            ],
            "Monywa": [
                "Monywa",
                "Thazi"
            ],
            "Myaung": [
                "Myanug"
            ],
            "Myinmu": [
                "Myinmu"
            ],
            "Nanyun": [
                "Nanyun"
            ],
            "Pale": [
                "Pale"
            ],
            "Phaungpyin": [
                "Phaungpyin"
            ],
            "Pinlebu": [
                "Pinlebu"
            ],
            "Sagaing": [
                "Sagaing",
                "Nyaungpinwine",
                "Ywathitgyi"
            ],
            "Sarlingyi": [
                "Sarlingyi"
            ],
            "Shwebo": [
                "Shwebo",
                "Kyaukmyaung"
            ],
            "Tamu": [
                "Tamu"
            ],
            "Taze": [
                "Taze"
            ],
            "Tigyaing": [
                "Tigyaing"
            ],
            "Wetlet": [
                "Wetlet"
            ],
            "Wuntho": [
                "Wuntho",
                "Nankhan"
            ],
            "YeU": [
                "YeU"
            ],
            "Yinmabin": [
                "Yinmabin"
            ]
        },


        "Ayeyarwady": {
            "Bogalay": [
                "Bogalay"
            ],
            "Ahmar": [
                "Ahmar"
            ],
            "Danubyu": [
                "Danubyu"
            ],
            "Dedaye": [
                "Dedaye",
                "Suukalap"
            ],
            "Einme": [
                "Einme"
            ],
            "Hainggyi": [
                "Hainggyi",
                "Kyonekuu"
            ],
            "Hinthada": [
                "Hinthada",
                "Nateban",
                "Hinthadauniversity",
                "Yonethalin"
            ],
            "Ingabu": [
                "Ingabu",
                "Kwingauk",
                "Mezalegine",
                "Nyaungkyo",
                "Zaungtan"
            ],
            "Kangyidaung": [
                "Kangyidaung",
                "Kanywa"
            ],
            "Kyaiklat": [
                "Kyaiklat",
                "Yonedaunt"
            ],
            "Kyankhin": [
                "Kyankhin"
            ],
            "Kyaunggone": [
                "Kyaunggone"
            ],
            "Kyonepyaw": [
                "Kyonepyaw",
                "Thaungyi"
            ],
            "Labutta": [
                "Labutta",
                "Kyarkan",
                "Kanbat"
            ],
            "Laymyethar": [
                "Laymyethar",
                "Khamoutsu"
            ],
            "Maubin": [
                "Maubin",
                "Shwetaunghmaw",
                "Sitchaung",
                "Yeelaekalay"
            ],
            "Mawlamyainggyun": [
                "Mawlamyainggyun",
                "Hlaingbone"
            ],
            "Myanaung": [
                "Myanaung",
                "Innbin",
                "Kanaung",
                "Ngapiseik",
                "Shwekyin"
            ],
            "Myaungmya": [
                "Myaungmya",
                "Sagarmyar",
                "Yetwinyekan"
            ],
            "Ngaputaw": [
                "Ngaputaw"
            ],
            "Ngathaingchaung": [
                "Ngathaingchaung",
                "Ngathaingchaung"
            ],
            "Ngwesaung": [
                "Ngwesaung",
                "Sinma"
            ],
            "Nyaungtone": [
                "Nyaungtone",
                "Sarmalout"
            ],
            "Pantanaw": [
                "Pantanaw"
            ],
            "Pathein": [
                "BED",
                "GCC",
                "GTC",
                "Kyitha",
                "Myetto",
                "Pathein",
                "Patheinuniversity"
            ],
            "Pyapon": [
                "Kyitha",
                "Kyonekadon",
                "Thaminhtaw",
                "Pyapon"
            ],
            "Pyinsalu": [
                "Pyinsalu"
            ],
            "Shwethaungyan": [
                "Shwethaungyan",
                "Chaungtha"
            ],
            "Thabaung": [
                "Thabaung"
            ],
            "Kyamange": [
                "Wakema"
            ],
            "Kyungone": [
                "Warkema"
            ],
            "Shwelaung": [
                "Warkema"
            ],
            "Ahthoke": [
                "Yegyi"
            ],
            "Ngapiseik": [
                "Yegyie"
            ],
            "Thidakonpyin": [
                "Yegyi"
            ],
            "Yodayartet": [
                "Yegyie"
            ],
            "Zaythala": [
                "Yegyi"
            ],
            "Zalun": [
                "Zalun"
            ]
        },



        "Naypyitaw": {
            "Detkhinathiri": [
                "Detkhinathiri"
            ],
            "Lewe": [
                "Lewe",
                "Alar",
                "Tharwuthti",
                "Thekawgyi"
            ],
            "Oketarathiri": [
                "Oketarathiri"
            ],
            "Pokebathiri": [
                "Pokebathiri"
            ],
            "Pyinmana": [
                "Pyinmana",
                "Pyinmana (MyoHaung)"
            ],
            "Shwemyoe": [
                "Tatkone"
            ],
            "Tatkone": [
                "Tatkone"
            ],
            "Zayyarthiri": [
                "Zayyarthiri"
            ]
        },

        "Mandalay": {
            "Mandalay": [
                "Chanmyathazi",
                "Chanayethazan",
                "Amarapura",
                "Yadanarponuniversity"
            ],
            "Kyaukpadaung": [
                "Kyaukpadaung",
                "Popa"
            ],
            "Kyaukse": [
                "Kyaukse",
                "Thanywa"
            ],
            "Madaya": [
                "Madaya"
            ],
            "Mahaaungmyae": [
                "Mandalayuniversity"
            ],
            "Mahlaing": [
                "Mahlaing"
            ],
            "Meikhtila": [
                "Meikhtila"
            ],
            "Myingyan": [
                "Myingyan",
                "Myingyanmyoma"
            ],
            "Myitthar": [
                "Myitthar"
            ],
            "Nahtoegyi": [
                "Nahtoegyi"
            ],
            "Ngazune": [
                "Ngazune"
            ],
            "Nyaungoo": [
                "Nyaungoo",
                "Bagan",
                "Singu"
            ],
            "Patheingyi": [
                "MTU",
                "Patheingyihtonbo",
                "Patheingyi"
            ],
            "Pyawbwe": [
                "Pyawbwe",
                "Yanaung"
            ],
            "Pyaygyidakhon": [
                "Pyaygyidakhon",
                "Sathmutmyothit"
            ],
            "Pyinoolwin": [
                "Pyinoolwin",
                "CSTC",
                "Padaythamyothit"
            ],
            "Sintgu": [
                "Latpanhla",
                "Htonegyi",
                "Sintgu"
            ],
            "Sintkaing": [
                "Sintkaing"
            ],
            "Tadau": [
                "Tadau"
            ],
            "Taungtha": [
                "Taungtha",
                "Semakan",
                "Welaung",
                "Ywathit"
            ],
            "Thabeikkyin": [
                "Thabeikkyin"
            ],
            "Tharzi": [
                "Tharzi",
                "Hanza",
                "Nyaungyan"
            ],
            "Wundwin": [
                "Wundwin",
                "Thedaw"
            ],
            "Yamethin": [
                "Theinkonegyi",
                "Yamethin"
            ]
        },




        "Bago": {
            "Bago": [
                "Bago",
                "Oakthamyothit",
                "Tarwayedagar",
                "Thayaaye"
            ],
            "Deiku": [
                "Ayethukha",
                "Phaungdawthi"
            ],
            "Gyobingauk": [
                "Gyobingauk"
            ],
            "Htantabin": [
                "Htantabin",
                "Zayatgyi"
            ],
            "Kawa": [
                "Kawa"
            ],
            "Kyaukgyi": [
                "Kyaukgyi"
            ],
            "Kyauktagar": [
                "Kyauktagar"
            ],
            "Letpadan": [
                "Letpadan"
            ],
            "Minhla": [
                "Minhla"
            ],
            "Moenyo": [
                "Moenyo"
            ],
            "Nattalin": [
                "Nattalin"
            ],
            "Nyaunglaybin": [
                "Nyaunglaybin"
            ],
            "Oakpho": [
                "Oakpho"
            ],
            "Oaktwin": [
                "Oaktwin"
            ],
            "Padaung": [
                "Padaung",
                "Htonebo"
            ],
            "Pandaung": [
                "Thuyetan"
            ],
            "Paukkhaung": [
                "Paukkhang"
            ],
            "Phyu": [
                "Phyu"
            ],
            "Pyay": [
                "Pyay"
            ],
            "Shwedaung": [
                "Shwedaung"
            ],
            "Shwekyin": [
                "Shwekyin"
            ],
            "Taungoo": [
                "Taungoo",
                "Kaytumadi"
            ],
            "Thanapin": [
                "Thanapin",
                "Kyungyi"
            ],
            "Tharrawaddy": [
                "Tharrawaddy"
            ],
            "Thegone": [
                "Thegone"
            ],
            "Waw": [
                "Waw"
            ],
            "Yedashe": [
                "Yedashe",
                "Swa",
                "Yeni"
            ],
            "Zeegon": [
                "Zeegon"
            ]
        },

        "Magwe": {
            "Aunglan": [
                "Aunglan",
                "Kyawswa"
            ],
            "Chauk": [
                "Chauk"
            ],
            "Gantgaw": [
                "Gantgaw",
                "Minywa"
            ],
            "Htilinn": [
                "Htilinn"
            ],
            "Kanma": [
                "Kanma",
                "Yenantha"
            ],
            "Magwe": [
                "Magwe",
                "Yanpae"
            ],
            "Minbu": [
                "Minbu"
            ],
            "Mindonn": [
                "Mindonn",
                "Minhla"
            ],
            "Myaing": [
                "Myaing"
            ],
            "Myothit": [
                "Myothit"
            ],
            "Natmauk": [
                "Matmauk"
            ],
            "Ngape": [
                "Ngape"
            ],
            "Pakokku": [
                "Pakokku"
            ],
            "Pauk": [
                "Pauk"
            ],
            "Pwintpyu": [
                "Pwintpyu"
            ],
            "Salinn": [
                "Salinn"
            ],
            "Saw": [
                "Saw"
            ],
            "Saytoketaya": [
                "Saytoketaya"
            ],
            "Seikpyu": [
                "Seikpyu"
            ],
            "Sinpaungwe": [
                "Sinpaungwe"
            ],
            "Taungtwinggyi": [
                "Taungtwinggyi"
            ],
            "Thayet": [
                "Thayet"
            ],
            "Yenanchaung": [
                "Yenanchaung",
                "Pinwa",
                "Nyaunghla"
            ],
            "Yezakyo": [
                "Yezakyo"
            ]
        },


        "Yangon": {
            "Yangon": [
                "Ahlone",
                "Bahan",
                "Botahtaung",
                "Coco Island",
                "Dagon",
                "Dagon Myothit (East)",
                "Dagon Myothit (Seikkan)",
                "Dagon Myothit (South)",
                "Dala",
                "Dawbon",
                "Hlaing",
                "Hlaingtharya (East)",
                "Hlaingtharya (West)",
                "Hlegu",
                "Hmawbi",
                "Htantabin",
                "Insein",
                "Kamayut",
                "Kawhmu",
                "Kayan",
                "Kungyangon",
                "Kyauktada",
                "Kyauktan",
                "Kyeemyindaing",
                "Lanmadaw",
                "Mayangone",
                "Mingalardon",
                "Mingalartaungnyunt",
                "Okkalapa (North)",
                "Okkalapa (South)",
                "Pabedan",
                "Pazundaung",
                "Sanchaung",
                "Seikgyikanaungto",
                "Shwe Pyi Thar",
                "Taikkyi",
                "Tamwe",
                "Tharkayta",
                "Thingangyun",
                "Twantay",
                "Yankin"
            ]
        }





    }

    window.onload = function()
    {
        var DistrictSelect = document.getElementById("DistrictSelectS");
        var UpazillaSelect = document.getElementById("UpazillaSelectS");
        var UnionSelect = document.getElementById("UnionSelectS");
        for(var x in subjectObject )
        {
            DistrictSelect.options[DistrictSelect.options.length] = new Option(x,x);
        }

        DistrictSelect.onchange = function()
        {
            UpazillaSelect.length = 1;
            UnionSelect.length = 1;

            for(var y in subjectObject[this.value])
            {
                UpazillaSelect.options[UpazillaSelect.options.length] = new Option(y,y);
            }
        }

        UpazillaSelect.onchange = function()
        {
            UnionSelect.length = 1;

            var z = subjectObject[DistrictSelect.value][this.value];
            for(var i =0;i<z.length;i++)
            {
                UnionSelect.options[UnionSelect.options.length] = new Option(z[i],z[i]);
            }

        }

    }
</script>

<body>
<!-- Start of Navbar -->
<div class="border-b-[1px] bg-amber-500 ">
    <div class="my-container">

        <!-- For Large Devices -->
        <div class="hidden lg:flex items-center justify-between">
            <!-- Back Arrow -->
            <div class="flex items-center ">
                <button onclick="window.location.href='Login.jsp'" class="text-white hover:text-red-500 transition duration-300">
                    <i class="fa-solid fa-arrow-left text-3xl"></i>
                </button>
            </div>

            <!-- Logo Centered -->
            <div class="flex-grow text-center">

                <h1 class="font-extrabold text-5xl text-white  py-4 px-5 border-b-amber-500 hover:border-b-white border-b-[2px]
                        ">edms<span class="text-red-500">.</span></h1>

            </div>

            <!-- User Icon -->
            <div class="flex justify-end items-center text-[18px]">
                <div class="tooltip tooltip-left" data-tip="Profile">
                    <a href="Profile_user.jsp" class="hover:text-white transition duration-300">
                        <i class="fa-regular fa-circle-user"></i>
                    </a>
                </div>
            </div>
        </div>

        <!-- For Medium and Small Devices -->
        <div class="navbar bg-base-100 lg:hidden bg-amber-500 min-h-[100px]">
            <div class="navbar-start flex items-center">
                <!-- Back Arrow -->
                <button onclick="window.location.href='Login.jsp'" class="text-white hover:text-red-500 transition duration-300">
                    <i class="fa-solid fa-arrow-left text-[40px]"></i>
                </button>
            </div>

            <!-- Logo Centered -->
            <div class="navbar-center flex justify-center">
                <a href='Home.jsp'>
                    <h1 class="font-extrabold text-[50px] text-white">edms<span class="text-red-500">.</span></h1>
                </a>
            </div>

            <!-- User Icon -->
            <div class="navbar-end">
                <a href="Profile_user.jsp" class="hover:text-[#F17829] transition duration-300">
                    <i class="fa-regular fa-circle-user text-[40px]"></i>
                </a>
            </div>
        </div>
    </div>
</div>




<div class="pt-[20px]">
    <!-- Your page content here -->
</div>


<!-- Form -->
<form class=" my-5 max-w-[800px] mx-auto p-6 bg-white border-2 border-orange-300 rounded-lg shadow-lg" action="Representative" method="POST" enctype="multipart/form-data"
>

    <label class="label">
        <span class="label-text">Representative Name</span>
    </label>
    <input
            id="usernameInput"
            name="Representativename"
            type="text"
            class="input-floral w-full"
            placeholder="Choose a Representative Name (only letters allowed)"
            required
            oninput="validateUsername()"
    />
    <span id="usernameError" class="text-red-500 text-sm"></span>


    <script>
        function validateUsername() {
            const usernameInput = document.getElementById('usernameInput');
            const usernameError = document.getElementById('usernameError');

            // Regular expression to allow only alphabetic characters
            const usernameRegex = /^[a-zA-Z]+$/;

            if (!usernameRegex.test(usernameInput.value)) {
                // Show error if the username contains invalid characters
                usernameError.textContent = 'Representative Name must contain only letters (A-Z or a-z).';
                usernameInput.classList.add('border-red-500');
                usernameInput.classList.remove('border-green-500');
            } else {
                // Clear error if the username is valid
                usernameError.textContent = '';
                usernameInput.classList.remove('border-red-500');
                usernameInput.classList.add('border-green-500');
            }
        }
    </script>



    <label class="label">
        <span class="label-text">Sheltername</span>
    </label>
    <input
            id="usernameInput"
            name="ShelterName"
            type="text"
            class="input-floral w-full"
            placeholder="Choose a sheltername (only letters allowed)"
            required
            oninput="validateUsername()"
    />
    <span id="usernameError" class="text-red-500 text-sm"></span>


    <script>
        function validateUsername() {
            const usernameInput = document.getElementById('usernameInput');
            const usernameError = document.getElementById('usernameError');

            // Regular expression to allow only alphabetic characters
            const usernameRegex = /^[a-zA-Z]+$/;

            if (!usernameRegex.test(usernameInput.value)) {
                // Show error if the username contains invalid characters
                usernameError.textContent = 'Sheltername must contain only letters (A-Z or a-z).';
                usernameInput.classList.add('border-red-500');
                usernameInput.classList.remove('border-green-500');
            } else {
                // Clear error if the username is valid
                usernameError.textContent = '';
                usernameInput.classList.remove('border-red-500');
                usernameInput.classList.add('border-green-500');
            }
        }
    </script>

    <label class="label">
        <span class="label-text">Email</span>
    </label>
    <input
            id="emailInput"
            name="Email"
            type="email"
            class="input-floral w-full"
            placeholder="Enter your email (e.g., example@gmail.com)"
            required
            oninput="validateEmail()"
    />
    <span id="emailError" class="text-red-500 text-sm"></span>



    <script>
        function validateEmail() {
            const emailInput = document.getElementById('emailInput');
            const emailError = document.getElementById('emailError');

            // Check if the email ends with "@gmail.com"
            const gmailRegex = /^[a-zA-Z0-9._%+-]+@gmail\.com$/;

            if (!gmailRegex.test(emailInput.value)) {
                // Show error if the email does not match the required format
                emailError.textContent = 'Email must be in the format "example@gmail.com".';
                emailInput.classList.add('border-red-500');
                emailInput.classList.remove('border-green-500');
            } else {
                // Clear error if the email is valid
                emailError.textContent = '';
                emailInput.classList.remove('border-red-500');
                emailInput.classList.add('border-green-500');
            }
        }
    </script>

    <!-- Password -->
    <div class="grid grid-cols-2 gap-4">
        <!-- Password -->
        <div>
            <label class="label">
                <span class="label-text">Password</span>
            </label>
            <input
                    id="password1"
                    name="password1"
                    type="password"
                    class="input-floral w-full"
                    placeholder="Enter password"
                    required
                    oninput="validatePassword()"
            />
            <span id="passwordError" class="text-red-500 text-sm"></span>
        </div>
        <!-- Re-enter Password -->
        <div>
            <label class="label">
                <span class="label-text">Re-enter Password</span>
            </label>
            <input
                    id="password2"
                    name="password2"
                    type="password"
                    class="input-floral w-full"
                    placeholder="Confirm password"
                    required
                    oninput="validatePasswordMatch()"
            />
            <span id="confirmPasswordError" class="text-red-500 text-sm"></span>
        </div>
    </div>



    <script>
        function validatePassword() {
            const password1 = document.getElementById('password1');
            const passwordError = document.getElementById('passwordError');

            // Strong password regex
            const passwordRegex = /^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}$/;

            if (!passwordRegex.test(password1.value)) {
                // Show error if password does not meet criteria
                passwordError.textContent = 'Password must be at least 8 characters long, include uppercase, lowercase, numbers, and special characters.';
                password1.classList.add('border-red-500');
                password1.classList.remove('border-green-500');
            } else {
                // Clear error if password is valid
                passwordError.textContent = '';
                password1.classList.remove('border-red-500');
                password1.classList.add('border-green-500');
            }
        }

        function validatePasswordMatch() {
            const password1 = document.getElementById('password1');
            const password2 = document.getElementById('password2');
            const confirmPasswordError = document.getElementById('confirmPasswordError');

            if (password1.value !== password2.value) {
                // Show error if passwords do not match
                confirmPasswordError.textContent = 'Passwords do not match.';
                password2.classList.add('border-red-500');
                password2.classList.remove('border-green-500');
            } else {
                // Clear error if passwords match
                confirmPasswordError.textContent = '';
                password2.classList.remove('border-red-500');
                password2.classList.add('border-green-500');
            }
        }
    </script>

    <!-- select type -->
    <label class="label">
        <span class="label-text">Select Type</span></label>
    <select
            class="select select-bordered  input-floral w-full"
            type="text"
            name="Type"
            required>
        <option disabled selected>Pick one</option>
        <option>Temporary</option>
        <option>Permanent</option>
    </select>


    <!-- Budget -->
    <label class="label">
        <span class="label-text">Funding</span>
    </label>
    <input
            id="budgetInput"
            name="Funding"
            type="text"
            class="input-floral w-full"
            placeholder="Enter Funding Amount (only numbers allowed)"
            required
            oninput="validateFunding()"
    />
    <span id="budgetError" class="text-red-500 text-sm"></span>

    <script>
        function validateFunding() {
            const budgetInput = document.getElementById('budgetInput');
            const budgetError = document.getElementById('budgetError');

            // Regular expression to allow only numbers (positive integers or decimal numbers)
            const budgetRegex = /^[0-9]+(\.[0-9]+)?$/;

            if (!budgetRegex.test(budgetInput.value)) {
                // Show error if the input contains non-numeric characters
                budgetError.textContent = 'Funding amount must be a number (e.g., 100).';
                budgetInput.classList.add('border-red-500');
                budgetInput.classList.remove('border-green-500');
            } else {
                // Clear error if the input is valid
                budgetError.textContent = '';
                budgetInput.classList.remove('border-red-500');
                budgetInput.classList.add('border-green-500');
            }
        }
    </script>


    <label class="label">
        <span class="label-text">Website URL</span>
    </label>
    <input
            name="URL"
            type="text"
            class="input-floral w-full"
            placeholder="Enter Website URL (e.g., https://example.com)"
            required />

    <!-- Image Upload -->
    <div class="form-control">
        <label for="myFile" class="label">
            <span class="label-text text-gray-800 font-medium">Photo for proof(certificate)</span>
        </label>
        <input
                class="block w-full text-sm text-gray-500 file:mr-4 file:py-2 file:px-4 file:rounded-full file:border-0 file:text-sm file:font-semibold file:bg-gradient-to-r file:from-yellow-300 file:to-white hover:file:bg-gradient-to-r hover:file:from-yellow-200 hover:file:to-white mb-4"
                type="file"
                id="myFile"
                name="Photo1"
                required />
    </div>

    <!-- Second Image Upload -->
    <div class="form-control">
        <input
                class="block w-full text-sm text-gray-500 file:mr-4 file:py-2 file:px-4 file:rounded-full file:border-0 file:text-sm file:font-semibold file:bg-gradient-to-r file:from-yellow-300 file:to-white hover:file:bg-gradient-to-r hover:file:from-yellow-200 hover:file:to-white mb-4"
                type="file"
                id="myFile"
                name="Photo2"
                required />
    </div>

    <label class="label">
        <span class="label-text">Mobile No</span>
    </label>
    <input
            id="mobileInput"
            name="Contact"
            type="text"
            class="input-floral w-full"
            placeholder="Enter Mobile Number (only numbers allowed eg;0923454321)"
            required
            oninput="validateMobile()"
    />
    <span id="mobileError" class="text-red-500 text-sm"></span>

    <script>
        function validateMobile() {
            const mobileInput = document.getElementById('mobileInput');
            const mobileError = document.getElementById('mobileError');

            // Regular expression to allow only numbers (exactly 10 digits)
            const mobileRegex = /^[0-9]+$/;

            if (!mobileRegex.test(mobileInput.value)) {
                // Show error if the input does not match 10 digits
                mobileError.textContent = 'Mobile number must be  digits.';
                mobileInput.classList.add('border-red-500');
                mobileInput.classList.remove('border-green-500');
            } else {
                // Clear error if the mobile number is valid
                mobileError.textContent = '';
                mobileInput.classList.remove('border-red-500');
                mobileInput.classList.add('border-green-500');
            }
        }
    </script>

    <div class="form-control">
        <label for="help-Count" class="label">
            <span class="label-text text-gray-800 font-medium">Affectedmale</span>
        </label>
        <input
                type="number"
                class="input-floral w-full"
                name="AffectedMale"
                required />
    </div>

    <div class="form-control">
        <label for="help-Count" class="label">
            <span class="label-text text-gray-800 font-medium">Affectedfemale</span>
        </label>
        <input
                type="number"
                class="input-floral w-full"
                name="AffectedFemale"
                required />
    </div>

    <div class="form-control">
        <label for="help-Count" class="label">
            <span class="label-text text-gray-800 font-medium">Affectedchildren</span>
        </label>
        <input
                type="number"
                class="input-floral w-full"
                name="AffectedChildren"
                required />
    </div>

    <div class="form-control">
        <label for="help-Count" class="label">
            <span class="label-text text-gray-800 font-medium">Stafftotal</span>
        </label>
        <input
                type="number"
                class="input-floral w-full"
                name="StaffTotal"
                required />
    </div>

    <!-- select district -->
    <div class="grid grid-cols-3 gap-4">
        <div>
            <label class="label">
                <span class="label-text">Select Division</span>
            </label>
            <select id="DistrictSelectS" class="select select-bordered input-floral w-full" name="Division" required>
                <option disabled selected>Add Divisions</option>
            </select>
        </div>
        <!-- Select District js -->

        <script>
            document.getElementById("DistrictSelectS").addEventListener("change", function() {
                var selectElement = document.getElementById("DistrictSelectS");
                var selectOption = selectElement.options[selectElement.selectedIndex];

                var selectedText = selectOption.text;

                // Use AJAX to send selectedText to server
                fetch("representative.jsp?jsValue=" + encodeURIComponent(selectedText))
                    .then(response => response.text())
                    .then(data => {
                        console.log(data); // Log the response from the server
                    })
                    .catch(error => {
                        console.error("Error:", error);
                    });
            });
        </script>

        <%
            String selectedDistrict = request.getParameter("jsValue");%>
        <input type="hidden" name="selectedDistrict" value="<%= selectedDistrict %>">

        <!-- select upazila -->
        <div>
            <label class="label">
                <span class="label-text">Select City</span>
            </label>
            <select id="UpazillaSelectS" class="select select-bordered input-floral w-full" name="City" required>
                <option disabled selected>Add Cities</option>
            </select>
        </div>

        <!-- Select Upazilla js -->

        <script>
            document.getElementById("UpazillaSelectS").addEventListener("change", function() {
                var selectElement = document.getElementById("UpazillaSelectS");
                var selectOption = selectElement.options[selectElement.selectedIndex];

                var selectedText = selectOption.text;

                // Use AJAX to send selectedText to server
                fetch("representative.jsp?UpValue=" + encodeURIComponent(selectedText))
                    .then(response => response.text())
                    .then(data => {



                        console.log(data); // Log the response from the server
                    })
                    .catch(error => {
                        console.error("Error:", error);
                    });
            });
        </script>

        <%String selectedUpazilla = request.getParameter("UpValue");%>
        <input type="hidden" name="selectedUpazilla" value="<%= selectedUpazilla %>">


        <!-- select union -->
        <div>
            <label class="label">
                <span class="label-text">Select Township</span>
            </label>
            <select id="UnionSelectS" class="select select-bordered input-floral w-full" name="Township" required>
                <option disabled selected>Add Townships</option>
            </select>
        </div>

        <script>
            const unionSelectDropDown = document.getElementById('UnionSelectS')
            unionSelectDropDown.addEventListener('change', function(){
                document.getElementById('selectedUnionHiddenBox').value = unionSelectDropDown.options[unionSelectDropDown.selectedIndex].text
            })
        </script>

        <!-- select Union js -->
        <script>
            document.getElementById("UnionSelectS").addEventListener("change", function() {
                var selectElement = document.getElementById("UnionSelectS");
                var selectOption = selectElement.options[selectElement.selectedIndex];

                var selectedText = selectOption.text;

                // Use AJAX to send selectedText to server
                fetch("representative.jsp?UnionValue=" + encodeURIComponent(selectedText))
                    .then(response => response.text())
                    .then(data => {
                        console.log(data); // Log the response from the server
                    })
                    .catch(error => {
                        console.error("Error:", error);
                    });
            });

        </script>

        <%

            String selectedUnion = request.getParameter("UnionValue");

						/* String aise="null";

						if(aise=="null"&& selectedUnion!=null){

					 PreparedStatement ps=con.prepareStatement("insert into setloc(Location)values(?)");
					 ps.setString(1,selectedUnion);
					 ps.executeUpdate();

						} */
        %>

        <input type="hidden" name="selectedUnion" id="selectedUnionHiddenBox" value="selectedUnion">
    </div>

    <label class="label">
        <span class="label-text">Capacity</span>
    </label>
    <input
            id="capacityInput"
            name="Capacity"
            type="text"
            class="input-floral w-full"
            placeholder="Enter Capacity (only numbers allowed)"
            required
            oninput="validateCapacity()"
    />
    <span id="capacityError" class="text-red-500 text-sm"></span>

    <label class="label">
        <span class="label-text">Activity</span></label>
    <select
            class="select select-bordered  input-floral w-full"
            type="text"
            name="Activity"
            required>
        <option disabled selected>Select Activity</option>
        <option>Active</option>
        <option>Halt</option>
        <option>Rest</option>
    </select>
    <span id="activityError" class="text-red-500 text-sm"></span>



    <label class="label">
        <span class="label-text">Priority</span>
    </label>
    <input
            id="priorityInput"
            name="Priority"
            type="text"
            class="input-floral w-full"
            placeholder="Enter Priority (only numbers allowed)"
            required
            oninput="validatePriority()"
    />
    <span id="priorityError" class="text-red-500 text-sm"></span>

    <label class="label">
        <span class="label-text">Total Priority</span>
    </label>
    <input
            id="totalPriorityInput"
            name="TotalPriority"
            type="text"
            class="input-floral w-full"
            placeholder="Enter Total Priority (only numbers allowed)"
            required
            oninput="validateTotalPriority()"
    />
    <span id="totalPriorityError" class="text-red-500 text-sm"></span>

    <script>
        // Regular expression for numeric validation
        const numberRegex = /^[0-9]+(\.[0-9]+)?$/;
        // Regular expression for alphabetic validation
        const textRegex = /^[a-zA-Z\s]+$/;

        function validateCapacity() {
            const capacityInput = document.getElementById('capacityInput');
            const capacityError = document.getElementById('capacityError');

            if (!numberRegex.test(capacityInput.value)) {
                capacityError.textContent = 'Capacity must be a number (e.g., 100).';
                capacityInput.classList.add('border-red-500');
                capacityInput.classList.remove('border-green-500');
            } else {
                capacityError.textContent = '';
                capacityInput.classList.remove('border-red-500');
                capacityInput.classList.add('border-green-500');
            }
        }

        function validatePriority() {
            const priorityInput = document.getElementById('priorityInput');
            const priorityError = document.getElementById('priorityError');

            if (!numberRegex.test(priorityInput.value)) {
                priorityError.textContent = 'Priority must be a number (e.g., 10).';
                priorityInput.classList.add('border-red-500');
                priorityInput.classList.remove('border-green-500');
            } else {
                priorityError.textContent = '';
                priorityInput.classList.remove('border-red-500');
                priorityInput.classList.add('border-green-500');
            }
        }

        function validateTotalPriority() {
            const totalPriorityInput = document.getElementById('totalPriorityInput');
            const totalPriorityError = document.getElementById('totalPriorityError');

            if (!numberRegex.test(totalPriorityInput.value)) {
                totalPriorityError.textContent = 'Total Priority must be a number (e.g., 50).';
                totalPriorityInput.classList.add('border-red-500');
                totalPriorityInput.classList.remove('border-green-500');
            } else {
                totalPriorityError.textContent = '';
                totalPriorityInput.classList.remove('border-red-500');
                totalPriorityInput.classList.add('border-green-500');
            }
        }
    </script>

    <!-- Bio -->
    <label class="label">Write Something about Goal and Work</label>
    <textarea
            class="textarea textarea-bordered h-24 input-floral w-full"
            placeholder="Bio"
            name="Description"
            required></textarea>

    <!-- Submit Button -->
    <div class="form-control">
        <input class="btn btn-warning w-full py-3 text-black  font-bold text-xl rounded-full shadow-lg transition transform hover:scale-105" type="submit" value="Submit">
    </div>
</form>
</div>
</div>
</div>
</div>


<div class='flex flex-col items-center justify-center gap-3 border-[1px] p-8 w-full'>
    <a href='Home.jsp'>
        <h1 class="font-extrabold text-5xl text-amber-600">edms<span class="text-red-500">.</span></h1>
    </a>
    <h3 class='text-[16px] text-[#7B7B7B] text-center'>EDMS - Your comprehensive resource for shelter,
        assistance, and information during times of crisis</h3>
    <h3 class='text-[16px] text-[#868686] text-center'>&copy; 2024 EDMS. All rights reserved.</h3>
</div>
</body>

</html>
