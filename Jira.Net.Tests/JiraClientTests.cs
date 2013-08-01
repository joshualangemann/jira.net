using NUnit.Framework;
using RestSharp;
using Shouldly;

namespace Jira.Net.Tests
{
    [TestFixture]
	public class JiraClientTests
    {
		[Test]
		public void WhenConstructing_ThenShouldCreateRestClientWithHttpBasiAuthenticator()
		{
			var client = new JiraClient("host", "username", "password");
			client.Client.Authenticator.GetType().ShouldBe(typeof(HttpBasicAuthenticator));
			client.Client.BaseUrl.ShouldBe("host");
		}
    }
}
