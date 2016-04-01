using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace Bookseeker
{
    public partial class TEST : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            Bookseeker _dbContext = new Bookseeker();
            IQueryable<Books> bookList;
            bookList = from books
                       in _dbContext.Books
                       where books.Genre == "Classics"
                       select books;

            gvTest.DataSource = bookList.ToList<Books>();
            gvTest.DataBind();

        }
    }
}