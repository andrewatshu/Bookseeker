using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace Bookseeker.classes
{
    public class Recommendation
    {
        public string ISBN { get; set; }
        public string Author { get; set; }
        public string Title { get; set; }
        public string Genre { get; set; }
        public string Keywords { get; set; }
        public string Description { get; set; }
        public string ImgUrl { get; set; }
        public decimal grRating { get; set; }
        public string purchaseUrl { get; set; }
        public bool showGrRating { get; set; }
        public bool showPurchaseUrl { get; set; }
        public string GRUrl { get; set; }
    }
}