/*Painting Bot Twitter Account
  Code to sort data received data from twitter and store it in a text file named mentionsData.txt
*/

import twitter4j.util.*;
import twitter4j.*;
import twitter4j.management.*;
import twitter4j.api.*;
import twitter4j.conf.*;
import twitter4j.json.*;
import twitter4j.auth.*;
import java.util.regex.*;//For pattern matching 

//Consumer Key and Consumer Secret for OAuth
static String OAuthConsumerKey = "OAUTH-CONSUMER-KEY";
static String OAuthConsumerSecret = "OAUTH-CONSUMER-SECRET";

//Access Token and Access Token Secret 
static String AccessToken = "ACCESS-TOKEN";
static String AccessTokenSecret = "ACCESS-TOKEN-SECRET";


Twitter twitter = new TwitterFactory().getInstance();
RequestToken requestToken;

int delayTime = 20000; // rate limit for OAuth is 350 requests per hour(~5 per minute) 
java.util.List mentions_list = null;

int capacity = 20;
ArrayList<String> mentions_StringList;

// Connecting to Twitter using OAuth
void connectTwitter()
{
  twitter.setOAuthConsumer(OAuthConsumerKey, OAuthConsumerSecret);
  AccessToken accessToken = loadAccessToken();
  twitter.setOAuthAccessToken(accessToken);
}
private static AccessToken loadAccessToken()
{
  return new AccessToken(AccessToken, AccessTokenSecret);
}

//Function to fetch mentions and store the relevant mentions in an ArrayList
void FetchMentions()
{
  try
  {
    mentions_list = twitter.getMentionsTimeline();
  }
  catch(TwitterException e)
  {
    println("Get timeline: " + e + " Status code: " + e.getStatusCode());
  }

  int mentions_storedCounter = 0;


  for (int i=0; i<mentions_list.size (); i++)
  {
    Status status = (Status)mentions_list.get(i);
    //This pattern matching snippet is to store the relevant mentions,which have the x,y and color value, in the arraylist  
    String mention = status.getText();
    String mentions_sifter_string = "x=|x = |y=|y = ";
    Pattern mentions_sifter_pattern = Pattern.compile(mentions_sifter_string);
    Matcher mentions_sifter_matcher = mentions_sifter_pattern.matcher(mention);
    boolean mentionOkay = mentions_sifter_matcher.find(); //Return 1 if the regular expresion(mattern_sifter_string) is found in the "mention"
    //println(mentionOkay);

    if (mentionOkay)
    {
      if (mentions_storedCounter < 20 ) //Store first 20 tweets , index from 0 to 19
      {
        mentions_storedCounter = mentions_storedCounter + 1;
        mentions_StringList.add(status.getText());
      }
    }
  }
}

//Function to store the x,y and color value in a table
void StoreValues()
{
  String non_digit = "\\D+"; //Matches non-digit numbers ... This is to get x and y values from the mention text
  String non_word = "\\W+|\\s+"; //Matches non-word characters ... This is the get the color value from mention
  Pattern non_digit_pattern = Pattern.compile(non_digit);
  Pattern non_word_pattern = Pattern.compile(non_word);

  String[] old_mentions = loadStrings("mentionsData.txt"); // not used till now (22-july-2014)
  PrintWriter output = createWriter("data/mentionsData.txt");

  String[] data = new String[3]; // To store data to the text file

  for (int i=0; i<mentions_StringList.size (); i++)
  {
    String mention = mentions_StringList.get(i);
    println(mention);
    String[] mention_splitList = split(mention, ';');
    for (int j=0; j<mention_splitList.length; j++)
    {
      Matcher non_digit_matcher = non_digit_pattern.matcher(mention_splitList[j]);
      String coordinate = non_digit_matcher.replaceAll("");
      //println(coordinate);
      if (j < 2)
      { 
        data[j] = coordinate;
      }
      if (j == 2) // This "if" is to store the color as the mention_splitList[2] (i.e.third element) does not have any digit 
      {
        String[] splitted = split(mention_splitList[j], '=');
        Matcher non_word_matcher = non_word_pattern.matcher(splitted[1]);
        String paintColor = non_word_matcher.replaceAll("");
        //println(paintColor);
        data[j] = paintColor;
      }
      //println(data[0] + "," + data[1] + "," +data[2]);
    }
    output.println(data[0] + "," + data[1] + "," +data[2]); // Store data to text file
  }
  output.flush();  // Flush all the data to the file
  output.close();  // Close the file
}

// loop to check if data values have been written to the text file
void printValues()
{
  String[] data = loadStrings("mentionsData.txt");
  for (int i = 0; i < data.length; i++)
  {
    println(data[i]);
  }
}

void setup()
{
  size(100, 100);
  background(0);
  mentions_StringList = new ArrayList<String>(20); //Create an empty array list
  connectTwitter();
}

void draw()
{
  FetchMentions(); //To get mentions from twitter and store latest twenty mentions in an ArrayList
  StoreValues(); // To parse the elements of array list to get x,y and color values and store the in a table
  printValues();
  mentions_StringList.clear();
  delay(delayTime);
}

