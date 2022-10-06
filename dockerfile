FROM mcr.microsoft.com/dotnet/sdk:6.0 AS build
WORKDIR /APIShell

# Copy csproj and restore as distinct layers
COPY app/*.csproj .
RUN dotnet restore

# Copy everything else and build website
COPY app/. .
RUN dotnet publish -c release -o /WebApp --no-restore

# Final stage / image
FROM mcr.microsoft.com/dotnet/aspnet:5.0
WORKDIR /WebApp
COPY --from=build /WebApp ./
ENTRYPOINT ["dotnet", "app.dll"]