# השתמש בתמונה הרשמית של .NET 6 ASP.NET Core כבסיס
FROM mcr.microsoft.com/dotnet/aspnet:6.0 AS base
WORKDIR /app
EXPOSE 80
EXPOSE 443

# השתמש בתמונה הרשמית של .NET SDK עבור תהליך הבנייה
FROM mcr.microsoft.com/dotnet/sdk:6.0 AS build
WORKDIR /src
COPY ["ChinessSale_server/ChinessSale_server.csproj", "ChinessSale_server/"]
RUN dotnet restore "ChinessSale_server/ChinessSale_server.csproj"
COPY . .
WORKDIR "/src/ChinessSale_server"
RUN dotnet build "ChinessSale_server.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "ChinessSale_server.csproj" -c Release -o /app/publish

# שלב הריצה של האפליקציה
FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "ChinessSale_server.dll"]
