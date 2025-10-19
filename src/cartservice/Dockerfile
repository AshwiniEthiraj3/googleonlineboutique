# ---------- Stage 1: Build ----------
FROM mcr.microsoft.com/dotnet/sdk:9.0 AS build
WORKDIR /src

# Copy project file and restore dependencies
COPY cartservice.sln .
COPY src/*.csproj ./src/
RUN dotnet restore ./src/cartservice.csproj

# Copy the rest of the source code
COPY . .

# Build the project
RUN dotnet publish ./src/cartservice.csproj -c Release -o /app/publish

# ---------- Stage 2: Runtime ----------
FROM mcr.microsoft.com/dotnet/aspnet:9.0 AS runtime
WORKDIR /app

# Copy built files from build stage
COPY --from=build /app/publish .

# Set environment variables (optional)
ENV ASPNETCORE_URLS=http://+:7070
EXPOSE 7070


ENTRYPOINT ["dotnet", "cartservice.dll"]
