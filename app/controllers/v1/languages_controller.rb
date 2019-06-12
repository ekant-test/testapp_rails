class V1::LanguagesController < V1::BaseController

  api :GET, '/languages?contains_all_languages=true', "Get list languages"
  example '
  {
    "code": 200,
    "message": "Get common languages successfully!",
    "data": {
      "show_company_code": true,
      "languages": [
        {
          "name": "All Languages"
        },
        {
          "name": "Afrikaans",
          "common_name": null,
          "iso_639_3": "afr",
          "iso_639_1": "af",
          "common": true,
          "type": "living"
        },
        {
          "name": "Arabic",
          "common_name": null,
          "iso_639_3": "ara",
          "iso_639_1": "ar",
          "common": true,
          "type": "living"
        },
        {
          "name": "Bengali",
          "common_name": null,
          "iso_639_3": "ben",
          "iso_639_1": "bn",
          "common": true,
          "type": "living"
        },
        {
          "name": "Tibetan",
          "common_name": null,
          "iso_639_3": "bod",
          "iso_639_1": "bo",
          "common": true,
          "type": "living"
        },
        {
          "name": "Bulgarian",
          "common_name": null,
          "iso_639_3": "bul",
          "iso_639_1": "bg",
          "common": true,
          "type": "living"
        },
        {
          "name": "Catalan",
          "common_name": null,
          "iso_639_3": "cat",
          "iso_639_1": "ca",
          "common": true,
          "type": "living"
        },
        {
          "name": "Czech",
          "common_name": null,
          "iso_639_3": "ces",
          "iso_639_1": "cs",
          "common": true,
          "type": "living"
        },
        {
          "name": "Welsh",
          "common_name": null,
          "iso_639_3": "cym",
          "iso_639_1": "cy",
          "common": true,
          "type": "living"
        },
        {
          "name": "Danish",
          "common_name": null,
          "iso_639_3": "dan",
          "iso_639_1": "da",
          "common": true,
          "type": "living"
        },
        {
          "name": "German",
          "common_name": null,
          "iso_639_3": "deu",
          "iso_639_1": "de",
          "common": true,
          "type": "living"
        },
        {
          "name": "Modern Greek (1453-)",
          "common_name": "Greek",
          "iso_639_3": "ell",
          "iso_639_1": "el",
          "common": true,
          "type": "living"
        },
        {
          "name": "English",
          "common_name": null,
          "iso_639_3": "eng",
          "iso_639_1": "en",
          "common": true,
          "type": "living"
        },
        {
          "name": "Estonian",
          "common_name": null,
          "iso_639_3": "est",
          "iso_639_1": "et",
          "common": true,
          "type": "living"
        },
        {
          "name": "Basque",
          "common_name": null,
          "iso_639_3": "eus",
          "iso_639_1": "eu",
          "common": true,
          "type": "living"
        },
        {
          "name": "Persian",
          "common_name": null,
          "iso_639_3": "fas",
          "iso_639_1": "fa",
          "common": true,
          "type": "living"
        },
        {
          "name": "Fijian",
          "common_name": null,
          "iso_639_3": "fij",
          "iso_639_1": "fj",
          "common": true,
          "type": "living"
        },
        {
          "name": "Finnish",
          "common_name": null,
          "iso_639_3": "fin",
          "iso_639_1": "fi",
          "common": true,
          "type": "living"
        },
        {
          "name": "French",
          "common_name": null,
          "iso_639_3": "fra",
          "iso_639_1": "fr",
          "common": true,
          "type": "living"
        },
        {
          "name": "Irish",
          "common_name": null,
          "iso_639_3": "gle",
          "iso_639_1": "ga",
          "common": true,
          "type": "living"
        },
        {
          "name": "Gujarati",
          "common_name": null,
          "iso_639_3": "guj",
          "iso_639_1": "gu",
          "common": true,
          "type": "living"
        },
        {
          "name": "Hebrew",
          "common_name": null,
          "iso_639_3": "heb",
          "iso_639_1": "he",
          "common": true,
          "type": "living"
        },
        {
          "name": "Hindi",
          "common_name": null,
          "iso_639_3": "hin",
          "iso_639_1": "hi",
          "common": true,
          "type": "living"
        },
        {
          "name": "Croatian",
          "common_name": null,
          "iso_639_3": "hrv",
          "iso_639_1": "hr",
          "common": true,
          "type": "living"
        },
        {
          "name": "Hungarian",
          "common_name": null,
          "iso_639_3": "hun",
          "iso_639_1": "hu",
          "common": true,
          "type": "living"
        },
        {
          "name": "Armenian",
          "common_name": null,
          "iso_639_3": "hye",
          "iso_639_1": "hy",
          "common": true,
          "type": "living"
        },
        {
          "name": "Indonesian",
          "common_name": null,
          "iso_639_3": "ind",
          "iso_639_1": "id",
          "common": true,
          "type": "living"
        },
        {
          "name": "Icelandic",
          "common_name": null,
          "iso_639_3": "isl",
          "iso_639_1": "is",
          "common": true,
          "type": "living"
        },
        {
          "name": "Italian",
          "common_name": null,
          "iso_639_3": "ita",
          "iso_639_1": "it",
          "common": true,
          "type": "living"
        },
        {
          "name": "Japanese",
          "common_name": null,
          "iso_639_3": "jpn",
          "iso_639_1": "ja",
          "common": true,
          "type": "living"
        },
        {
          "name": "Georgian",
          "common_name": null,
          "iso_639_3": "kat",
          "iso_639_1": "ka",
          "common": true,
          "type": "living"
        },
        {
          "name": "Central Khmer",
          "common_name": null,
          "iso_639_3": "khm",
          "iso_639_1": "km",
          "common": true,
          "type": "living"
        },
        {
          "name": "Korean",
          "common_name": null,
          "iso_639_3": "kor",
          "iso_639_1": "ko",
          "common": true,
          "type": "living"
        },
        {
          "name": "Latin",
          "common_name": null,
          "iso_639_3": "lat",
          "iso_639_1": "la",
          "common": true,
          "type": "ancient"
        },
        {
          "name": "Latvian",
          "common_name": null,
          "iso_639_3": "lav",
          "iso_639_1": "lv",
          "common": true,
          "type": "living"
        },
        {
          "name": "Lithuanian",
          "common_name": null,
          "iso_639_3": "lit",
          "iso_639_1": "lt",
          "common": true,
          "type": "living"
        },
        {
          "name": "Malayalam",
          "common_name": null,
          "iso_639_3": "mal",
          "iso_639_1": "ml",
          "common": true,
          "type": "living"
        },
        {
          "name": "Marathi",
          "common_name": null,
          "iso_639_3": "mar",
          "iso_639_1": "mr",
          "common": true,
          "type": "living"
        },
        {
          "name": "Macedonian",
          "common_name": null,
          "iso_639_3": "mkd",
          "iso_639_1": "mk",
          "common": true,
          "type": "living"
        },
        {
          "name": "Maltese",
          "common_name": null,
          "iso_639_3": "mlt",
          "iso_639_1": "mt",
          "common": true,
          "type": "living"
        },
        {
          "name": "Mongolian",
          "common_name": null,
          "iso_639_3": "mon",
          "iso_639_1": "mn",
          "common": true,
          "type": "living"
        },
        {
          "name": "Maori",
          "common_name": null,
          "iso_639_3": "mri",
          "iso_639_1": "mi",
          "common": true,
          "type": "living"
        },
        {
          "name": "Malay",
          "common_name": null,
          "iso_639_3": "msa",
          "iso_639_1": "ms",
          "common": true,
          "type": "living"
        },
        {
          "name": "Nepali",
          "common_name": null,
          "iso_639_3": "nep",
          "iso_639_1": "ne",
          "common": true,
          "type": "living"
        },
        {
          "name": "Dutch",
          "common_name": null,
          "iso_639_3": "nld",
          "iso_639_1": "nl",
          "common": true,
          "type": "living"
        },
        {
          "name": "Norwegian",
          "common_name": null,
          "iso_639_3": "nor",
          "iso_639_1": "no",
          "common": true,
          "type": "living"
        },
        {
          "name": "Panjabi",
          "common_name": null,
          "iso_639_3": "pan",
          "iso_639_1": "pa",
          "common": true,
          "type": "living"
        },
        {
          "name": "Polish",
          "common_name": null,
          "iso_639_3": "pol",
          "iso_639_1": "pl",
          "common": true,
          "type": "living"
        },
        {
          "name": "Portuguese",
          "common_name": null,
          "iso_639_3": "por",
          "iso_639_1": "pt",
          "common": true,
          "type": "living"
        },
        {
          "name": "Quechua",
          "common_name": null,
          "iso_639_3": "que",
          "iso_639_1": "qu",
          "common": true,
          "type": "living"
        },
        {
          "name": "Romanian",
          "common_name": null,
          "iso_639_3": "ron",
          "iso_639_1": "ro",
          "common": true,
          "type": "living"
        },
        {
          "name": "Russian",
          "common_name": null,
          "iso_639_3": "rus",
          "iso_639_1": "ru",
          "common": true,
          "type": "living"
        },
        {
          "name": "Slovak",
          "common_name": null,
          "iso_639_3": "slk",
          "iso_639_1": "sk",
          "common": true,
          "type": "living"
        },
        {
          "name": "Slovenian",
          "common_name": null,
          "iso_639_3": "slv",
          "iso_639_1": "sl",
          "common": true,
          "type": "living"
        },
        {
          "name": "Samoan",
          "common_name": null,
          "iso_639_3": "smo",
          "iso_639_1": "sm",
          "common": true,
          "type": "living"
        },
        {
          "name": "Spanish",
          "common_name": null,
          "iso_639_3": "spa",
          "iso_639_1": "es",
          "common": true,
          "type": "living"
        },
        {
          "name": "Albanian",
          "common_name": null,
          "iso_639_3": "sqi",
          "iso_639_1": "sq",
          "common": true,
          "type": "living"
        },
        {
          "name": "Serbian",
          "common_name": null,
          "iso_639_3": "srp",
          "iso_639_1": "sr",
          "common": true,
          "type": "living"
        },
        {
          "name": "Swahili",
          "common_name": null,
          "iso_639_3": "swa",
          "iso_639_1": "sw",
          "common": true,
          "type": "living"
        },
        {
          "name": "Swedish",
          "common_name": null,
          "iso_639_3": "swe",
          "iso_639_1": "sv",
          "common": true,
          "type": "living"
        },
        {
          "name": "Tamil",
          "common_name": null,
          "iso_639_3": "tam",
          "iso_639_1": "ta",
          "common": true,
          "type": "living"
        },
        {
          "name": "Tatar",
          "common_name": null,
          "iso_639_3": "tat",
          "iso_639_1": "tt",
          "common": true,
          "type": "living"
        },
        {
          "name": "Telugu",
          "common_name": null,
          "iso_639_3": "tel",
          "iso_639_1": "te",
          "common": true,
          "type": "living"
        },
        {
          "name": "Thai",
          "common_name": null,
          "iso_639_3": "tha",
          "iso_639_1": "th",
          "common": true,
          "type": "living"
        },
        {
          "name": "Tonga (Tonga Islands)",
          "common_name": null,
          "iso_639_3": "ton",
          "iso_639_1": "to",
          "common": true,
          "type": "living"
        },
        {
          "name": "Turkish",
          "common_name": null,
          "iso_639_3": "tur",
          "iso_639_1": "tr",
          "common": true,
          "type": "living"
        },
        {
          "name": "Ukrainian",
          "common_name": null,
          "iso_639_3": "ukr",
          "iso_639_1": "uk",
          "common": true,
          "type": "living"
        },
        {
          "name": "Urdu",
          "common_name": null,
          "iso_639_3": "urd",
          "iso_639_1": "ur",
          "common": true,
          "type": "living"
        },
        {
          "name": "Uzbek",
          "common_name": null,
          "iso_639_3": "uzb",
          "iso_639_1": "uz",
          "common": true,
          "type": "living"
        },
        {
          "name": "Vietnamese",
          "common_name": null,
          "iso_639_3": "vie",
          "iso_639_1": "vi",
          "common": true,
          "type": "living"
        },
        {
          "name": "Xhosa",
          "common_name": null,
          "iso_639_3": "xho",
          "iso_639_1": "xh",
          "common": true,
          "type": "living"
        },
        {
          "name": "Chinese",
          "common_name": null,
          "iso_639_3": "zho",
          "iso_639_1": "zh",
          "common": true,
          "type": "living"
        }
      ]
    }
  }'
  param :contains_all_languages, String, :desc => "option show all language or not!", :required => true
  def index
    common_languages = LanguageList::COMMON_LANGUAGES.as_json.sort_by { |k| k["name"] }
    if params[:contains_all_languages] == 'true'
      common_languages = [{"name" => "All Languages"}] + common_languages
    end
    render json: success_message("Get common languages successfully!", {
        show_company_code: Setting.first.show_company_text,
        languages: common_languages
      })
  end
end
