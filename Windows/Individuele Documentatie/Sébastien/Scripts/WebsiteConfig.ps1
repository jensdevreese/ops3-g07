﻿Configuration WebsiteConfig{
	Node WSR2-1 
	{
		WindowsFeature WebServer1 
		{
			Name = "Web-Server"
			DependsOn = "[WindowsFeature]ASP"
		}

		WindowsFeature ASP 
		{
			Name = "Web-Asp-Net45"
		}
	}
}
WebsiteConfig