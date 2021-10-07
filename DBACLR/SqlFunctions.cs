using System;
using System.Data.SqlTypes;
using Microsoft.SqlServer.Server;
using System.Text.RegularExpressions;


public partial class UserDefinedFunctions
{
    [SqlFunction(IsDeterministic = true, IsPrecise = true)]
    public static SqlString RegExReplace(SqlString expression, SqlString pattern, SqlString replace)
    {
        if (expression.IsNull || pattern.IsNull || replace.IsNull)
            return SqlString.Null;

        Regex r = new Regex(pattern.ToString());

        return new SqlString(r.Replace(expression.ToString(), replace.ToString()));
    }

    [SqlFunction(IsDeterministic = true, IsPrecise = true)]
    public static string removeInvalidCharacters(string inputValue, string invalidCharactersPattern, string replacementCharacters)
    {

        Regex rgx = new Regex(invalidCharactersPattern);
        return rgx.Replace(inputValue, replacementCharacters);

    }

    [SqlFunction(IsDeterministic = true, IsPrecise = true)]
    public static string removeExtraWhiteSpaces(string inputValue)
    {
        string extraWhiteSpaces = @"\s+";
        string singleWhiteSpace = " ";

        Regex rgx = new Regex(extraWhiteSpaces);
        return rgx.Replace(inputValue, singleWhiteSpace);
    }

    [SqlFunction(IsDeterministic = true, IsPrecise = true)]
    public static string removeAllSpaces(string inputValue)
    {
        string whiteSpacePattern = @"\s+";
        string replacement = "";

        Regex rgx = new Regex(whiteSpacePattern);
        return rgx.Replace(inputValue, replacement);
    }

    [SqlFunction(IsDeterministic = true, IsPrecise = true)]
    public static string EvaluateRegex(string pattern, string evalString)
    {
        Regex rg = new Regex(pattern);
        string retval = "";
        MatchCollection matches = rg.Matches(evalString);
        for (int count = 0; count < matches.Count; count++)
        {
            retval += matches[count].Value;
        }
        return retval;
    }

}
