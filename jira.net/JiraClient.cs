using RestSharp;
using Jira.Net;


namespace Jira.Net
{
	public class JiraClient : IJiraClient
	{
		private IRestClient _client;

		public JiraClient(string host, string username, string password)
		{
			_client = new RestClient(host)
			{
				Authenticator = new HttpBasicAuthenticator(username, password)
			};
		}

		public string Get(string resource)
		{
			var request = new RestRequest(resource);
			var response = _client.Execute(request);
			var content = response.Content;
			return content;
		}
	}
}
