using Newtonsoft.Json.Linq;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Linq.Expressions;
using System.Net.Http;
using System.Threading.Tasks;

namespace MvcMovie.Models
{
    public static class MoviesHelper
    {
        //#region
        //private static HashSet<Movie> _validatedMoviesCache = PreloadCache();
        //private static HashSet<Movie> PreloadCache()
        //{
        //    var movies = new HashSet<Movie>();
        //    for (int i = 0; i <= 500000; i++)
        //    {
        //        movies.Add(new Movie());
        //    }
        //    return new HashSet<Movie>();
        //}
        //#endregion


        // START HERE:
        // - Get an API key for tmdb.com or uncomment the return statement on line 66
        // - Run a CPU Usage Profling session by opening the performance profiling 
        //   tools (Alt+F2 or Debug>Performance Profiler...)
        // - Run the script in loadScript/addMovies (requires ruby)
        // - Explore the diagsession
        // - Comment out the region below, and uncomment the region above and repeat the same steps
        // - Compare the diagsession files to see the perf improvements between using LinkedList vs HashSet
        #region
        private static LinkedList<Movie> _validatedMoviesCache = PreloadCache();
        private static LinkedList<Movie> PreloadCache()
        {
            var movies = new LinkedList<Movie>();
            for (int i = 0; i <= 500000; i++)
            {
                movies.AddLast(new Movie());
            }
            return movies;
        }
        #endregion

        public static async Task<bool> ValidateInput(Movie movie)
        {
            // Check the cache to see if I've added this movie before
            if (_validatedMoviesCache.Contains(movie))
            {
                return true;
            }
            // If I haven't, validate the content with movie database API after caching it
            _validatedMoviesCache.AddLast(movie);
            // _validatedMoviesCache.Add(movie);
            return await CheckTMDB(movie).ConfigureAwait(false);
        }

        // Calls TMDb (The Movie Database) API and checks if the movie exists
        private static async Task<bool> CheckTMDB(Movie movie)
        {
            // For an API Key, go to https://www.themoviedb.org/settings/api
            // Or uncomment the next line to skip this API call.
            // return true;
            string api_key = "";
            // Search for the movie
            HttpClient client = new HttpClient();
            string url = String.Format("https://api.themoviedb.org/3/search/movie?api_key={0}&language=en-US&query={1}&page=1&include_adult=false", api_key, movie.Title);            
            var stringTask = client.GetStringAsync(url);
            var msg = await stringTask;
            JObject response = JObject.Parse(msg);
            JArray responseResults = (JArray)response["results"];
            return responseResults.HasValues ? true : false;            
        }
    }

}
