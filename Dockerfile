#See https://aka.ms/containerfastmode to understand how Visual Studio uses this Dockerfile to build your images for faster debugging.

FROM mcr.microsoft.com/dotnet/runtime:6.0 AS base
WORKDIR /app

FROM mcr.microsoft.com/dotnet/sdk:6.0 AS build
WORKDIR /src
COPY ["ConsoleApp_Docker_Core/ConsoleApp_Docker_Core.csproj", "ConsoleApp_Docker_Core/"]
RUN dotnet restore "ConsoleApp_Docker_Core/ConsoleApp_Docker_Core.csproj"
COPY . .
WORKDIR "/src/ConsoleApp_Docker_Core"
RUN dotnet build "ConsoleApp_Docker_Core.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "ConsoleApp_Docker_Core.csproj" -c Release -o /app/publish

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "ConsoleApp_Docker_Core.dll"]