# Stage 1: Build
FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
WORKDIR /src

# Copy solution and project file
COPY CounterApi.sln ./
COPY src/CounterApi.csproj ./src/

# Restore dependencies
RUN dotnet restore CounterApi.sln

# Copy the rest of the source code
COPY . .

# Build the project
RUN dotnet build CounterApi.sln -c Release -o /app/build

# Stage 2: Publish
FROM build AS publish
RUN dotnet publish CounterApi.sln -c Release -o /app/publish

# Stage 3: Runtime image
FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS final
WORKDIR /app
COPY --from=publish /app/publish .

ENTRYPOINT ["dotnet", "CounterApi.dll"]
