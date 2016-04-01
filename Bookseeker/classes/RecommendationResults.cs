using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Data;
using System.Net;
using System.IO;
using System.Xml;

namespace Bookseeker.classes
{
    public class RecommendationResults
    {
        public int RequestID;
        public int UserID;
        public string RequestGenre;
        public string RequestPrimaryKeyword;
        public bool ShowPurchaseLink;
        public bool ShowGoodreadsRating;
        private Bookseeker _dbContext;

        public RecommendationResults(int uID, string genre, string priKeyword, bool showPurchase, bool showGRRating)
        {
            this.UserID = uID;
            this.RequestGenre = genre;
            this.RequestPrimaryKeyword = priKeyword;
            this.ShowPurchaseLink = showPurchase;
            this.ShowGoodreadsRating = showGRRating;
            this._dbContext = new Bookseeker();
        }

        public IList<Recommendation> GetResults()
        {
            IQueryable<Recommendation> booksFullMatch;
            IQueryable<Recommendation> booksPartialMatch;

            booksFullMatch = from books in _dbContext.Books
                             from bookKeyLink in _dbContext.Book_Keyword_Link
                             from keyword in _dbContext.Keywords
                             where books.Genre == this.RequestGenre
                             where bookKeyLink.ISBN == books.ISBN
                             where keyword.KeywordID == bookKeyLink.KeywordID
                             where keyword.Keyword == this.RequestPrimaryKeyword
                             select new Recommendation
                             {
                                ISBN = books.ISBN.ToString(),
                                Author = books.Author_Firstname + " " + books.Author_Surname,
                                Title = books.Title,
                                Genre = books.Genre,
                                showGrRating = this.ShowGoodreadsRating,
                                showPurchaseUrl = this.ShowPurchaseLink
                             };

            booksPartialMatch = from books in _dbContext.Books
                                from bookKeyLink in _dbContext.Book_Keyword_Link
                                from keyword in _dbContext.Keywords
                                where bookKeyLink.ISBN == books.ISBN
                                where keyword.KeywordID == bookKeyLink.KeywordID
                                where (keyword.Keyword == this.RequestPrimaryKeyword || books.Genre == this.RequestGenre)
                                select new Recommendation
                                {
                                    ISBN = books.ISBN.ToString(),
                                    Author = books.Author_Firstname + " " + books.Author_Surname,
                                    Title = books.Title,
                                    Genre = books.Genre,
                                    showGrRating = this.ShowGoodreadsRating,
                                    showPurchaseUrl = this.ShowPurchaseLink
                                };

            if (booksFullMatch.Count() > 0)
            {
                if (booksFullMatch.Count() >= 5)
                {
                    //There are at least 5 results matching both requirements
                    return GetExtraData(booksFullMatch.OrderBy(x => Guid.NewGuid()).Take(5).ToList());
                }
                else
                {
                    //There are some results (< 5) matching both requirements so use them and make up the rest from partial matches
                    //First remove good results from the partial match list
                    foreach(Recommendation rec in booksFullMatch)
                    {
                        foreach(Recommendation partRec in booksPartialMatch)
                        {
                            if(rec.ISBN == partRec.ISBN)
                            {
                                booksPartialMatch = booksPartialMatch.Where(x => x.ISBN != rec.ISBN);
                            }
                        }
                    }
                    
                    List<Recommendation> booksFullandPartial = new List<Recommendation>();
                    booksFullandPartial.AddRange(booksFullMatch.ToList());
                    booksFullandPartial.AddRange(booksPartialMatch.OrderBy(x => Guid.NewGuid()).Take(5 - booksFullMatch.Count()).ToList());
                    return GetExtraData(booksFullandPartial);
                }
            }
            else
            {
                return GetExtraData(booksPartialMatch.OrderBy(x => Guid.NewGuid()).Take(5).ToList());
            }
        }

        private string GetKeywordsFromISBN(string ISBN)
        {
            string keywords = "";

            IQueryable<string> keywordsList = from bookKeyLink in _dbContext.Book_Keyword_Link
                                              from keyword in _dbContext.Keywords
                                              where bookKeyLink.ISBN.ToString() == ISBN
                                              where keyword.KeywordID == bookKeyLink.KeywordID
                                              select keyword.Keyword;
            
            foreach(string str in keywordsList)
            {
                if(keywords == "")
                {
                    keywords += str;
                }
                else
                {
                    keywords += ", " + str;
                }
            }
            return keywords;
        }

        private IList<Recommendation> GetExtraData(IList<Recommendation> booklist)
        {
             foreach (Recommendation book in booklist)
            {
                string requestURL = "https://www.goodreads.com/book/isbn?isbn=" + book.ISBN + "&format=xml&key=HG2js0zOrGndSzzug7WHA";

                try
                {
                    XmlReader xmlReader = XmlReader.Create(requestURL);

                    xmlReader.ReadToDescendant("book");
                    
                    xmlReader.ReadToDescendant("image_url");
                    book.ImgUrl = xmlReader.ReadInnerXml().Replace("<![CDATA[", "").Replace("]]>", "");

                    xmlReader.ReadToNextSibling("description");
                    book.Description = xmlReader.ReadInnerXml().Replace("<![CDATA[", "").Replace("]]>", "");

                    xmlReader.ReadToNextSibling("average_rating");
                    book.grRating = Convert.ToDecimal(xmlReader.ReadInnerXml());

                    xmlReader.ReadToNextSibling("link");
                    book.GRUrl = xmlReader.ReadInnerXml().Replace("<![CDATA[", "").Replace("]]>", "");
                }
                catch
                {
                    book.ImgUrl = "Data not Found";
                    book.Description = "Data not Found";
                    book.grRating = 0;
                }

                //Pause execution for 1 second because of request frequency limit with Goodreads API
                System.Threading.Thread.Sleep(1000);
            }

            booklist = booklist.OrderByDescending(x => x.grRating).ToList();
            
            foreach(Recommendation book in booklist)
            {
                book.Keywords = GetKeywordsFromISBN(book.ISBN);
            }

            return booklist;
        }

    }
}