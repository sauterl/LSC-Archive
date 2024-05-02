using JSON, CSV, DataFrames, Statistics, DataFramesMeta, Latexify;

# DRES files
run20 = JSON.parsefile("2020/LSC-Official.json");
run21 = JSON.parsefile("2021/Official Run.json");
run22 = JSON.parsefile("2022/LSC22.json");
run23 = JSON.parsefile("2023/LSC23.json");

# Resulting DataFrame with statistics overview
stats = DataFrame(Year=Int[],Teams=Int[], Groups=Int[], Tasks=Int[], Submissions=Int[]);

# LSC20
nbTeams = length(run20["competitionDescription"]["teams"]);
nbGroups = length(run20["competitionDescription"]["taskGroups"]);
tasks = filter(x -> x["hasStarted"] && (length(x["submissions"]) > 0), run20["runs"]); # there is a task LSC58 has been started twice, once without submissions
nbTasks = length(tasks);

# Build submissions DataFrame

submissions = DataFrame[];

for t in tasks
    taskName = t["task"]["name"];
    taskGroup = t["task"]["taskGroup"]["name"];
    taskStart = t["started"] + 5000 # Five seconds countdown induced offset
    
    for s in t["submissions"]
        push!(submissions, DataFrame(
            task=taskName,
            group=taskGroup,
            time=s["timestamp"]-taskStart,
            member=s["member"],
            team=s["team"],
            item=s["item"]["name"],
            status=s["status"]
        ));
    end
end
submissions = vcat(submissions...);
nbSubmissions = size(submissions,1);

push!(stats, (2020, nbTeams, nbGroups, nbTasks, nbSubmissions));
#---

# LSC21
nbTeams = length(run21["description"]["teams"]);
teamsMap = Dict(map(x -> x["uid"] => x["name"], run21["description"]["teams"]));
nbGroups = length(run21["description"]["taskGroups"]);
tasks = filter( x -> x["hasStarted"], run21["tasks"]);
nbTasks = length(tasks);

# Build submisisons table
submissions = DataFrame[];
for t in tasks
    taskName = t["description"]["name"];
    taskGroup = t["description"]["taskGroup"]["name"];
    taskStart = t["started"] + 5000; # five seconds countdown is added
    
    for s in t["submissions"]
        push!(submissions, DataFrame(
            task=taskName,
            group=taskGroup,
            time=s["timestamp"] - taskStart,
            team=teamsMap[s["teamId"]],
            member=s["memberId"],
            item=s["item"]["name"],
            status=s["status"]
        ));
    end
end
submissions = vcat(submissions...);

nbSubmissions = size(submissions,1);

# Fill 21 data to DataFrame
push!(stats, (2021, nbTeams, nbGroups, nbTasks, nbSubmissions));
#---

# LSC22
nbTeams = length(run22["description"]["teams"]);
teamsMap = Dict(map(x -> x["uid"] => x["name"], run22["description"]["teams"]));
nbGroups = length(run22["description"]["taskGroups"]);
tasks = filter( x -> x["hasStarted"], run22["tasks"]);
nbTasks = length(tasks);

# Build submisisons table
submissions = DataFrame[];
for t in tasks
    taskName = t["description"]["name"];
    taskGroup = t["description"]["taskGroup"]["name"];
    taskStart = t["started"] + 5000; # five seconds countdown is added
    
    for s in t["submissions"]
        push!(submissions, DataFrame(
            task=taskName,
            group=taskGroup,
            time=s["timestamp"] - taskStart,
            team=teamsMap[s["teamId"]],
            member=s["memberId"],
            item=s["item"]["name"],
            status=s["status"]
        ));
    end
end
submissions = vcat(submissions...);

nbSubmissions = size(submissions,1);

# Fill 22 data to DataFrame
push!(stats, (2022, nbTeams, nbGroups, nbTasks, nbSubmissions));
#---

# LSC23
nbTeams = length(run23["description"]["teams"]);
teamsMap = Dict(map(x -> x["uid"] => x["name"], run23["description"]["teams"]));
nbGroups = length(run23["description"]["taskGroups"]);
tasks = filter( x -> x["hasStarted"], run23["tasks"]);
nbTasks = length(tasks);

# Build submisisons table
submissions = DataFrame[];
for t in tasks
    taskName = t["description"]["name"];
    taskGroup = t["description"]["taskGroup"]["name"];
    taskStart = t["started"] + 5000; # five seconds countdown is added
    
    for s in t["submissions"]
        push!(submissions, DataFrame(
            task=taskName,
            group=taskGroup,
            time=s["timestamp"] - taskStart,
            team=teamsMap[s["teamId"]],
            member=s["memberId"],
            answer=haskey(s,"item") ? s["item"]["name"] : s["text"],
            status=s["status"]
        ));
    end
end
submissions = vcat(submissions...);

nbSubmissions = size(submissions,1);

# Fill 23 data to DataFrame
push!(stats, (2023, nbTeams, nbGroups, nbTasks, nbSubmissions));
#---

# Print results
stats
latexify(stats[:,:], env=:table, latex=false)