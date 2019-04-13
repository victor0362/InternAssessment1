const mysql = require('mysql');
const express = require('express');
var app = express();
const path = require('path');
const bodyparser = require('body-parser');

// MySQL db set up and test for connection
var mysqlConnection = mysql.createConnection({
	host: 'localhost',
	user: 'root',
	password: 'loginpassword',
	database: 'job_board',
	multipleStatements: true
});

mysqlConnection.connect((err) =>{
	if(!err)
		console.log('DB connection succeded');
	else
		console.log('DB connection failed \n Error: '+JSON.stringify(err,undefined, 2));
});

// Config
app.use(bodyparser.urlencoded({ extended: false }))
app.use(bodyparser.json());
app.set('views',path.join(__dirname,'view'));
app.set('view engine', 'ejs');

// callback function for Database query
const queryJob = (sql, insert, callback)=>{
	if(insert != null){
		mysqlConnection.query(sql,insert,(err,results)=>{
			if(err) callback(err);
			else
				callback(null,results);
		});
	} else {
		mysqlConnection.query(sql,(err,results)=>{
			if(err) callback(err);
			else
				callback(null,results);
		});
	}
};

/* ----------------------------CRUD function of MYSQL database-------------------------------*/
// ADD Job Title
app.post('/api/addJobTitle', (req,res)=>{
	console.log("adding Job Title...");
	mysqlConnection.query('SELECT job_title.JobTitle FROM job_title WHERE JobTitle = ?',req.body.title,(err,result)=>{
		if(result.length>0){
			res.render('index',{result: `${req.body.title} is already inside the db`, listItem: null})
		} else {
			mysqlConnection.query('INSERT INTO job_board.job_title (JobTitle) VALUES (?)',req.body.title,(err,result) =>{
				console.log("Insert into job_title successful");
			});
			res.render('index',{result: `Job Title, ${req.body.title} ,has been added`, listItem: [`<li>Job Title: ${req.body.title}</li>`]});
		}
	});
});

// ADD Job-Nature
app.post('/api/addJobNature', (req,res)=>{
	console.log("adding Job Nature...");
	mysqlConnection.query('SELECT function_nature.Nature FROM function_nature WHERE Nature = ?',req.body.nature,(err,result)=>{
		if(result.length>0){
			res.render('index',{result: `${req.body.nature} is already inside the db`, listItem: null})
		} else {
			mysqlConnection.query('INSERT INTO job_board.function_nature (Nature) VALUES (?)',req.body.nature,(err,result) =>{
				console.log("Insert into function_nature successful");
			});
			res.render('index',{result: `Job Nature, ${req.body.nature} ,has been added`, listItem: [`<li>Job Nature: ${req.body.nature}</li>`]});
		}
	});
});

// ADD Job function
app.post('/api/addJobFunction', (req,res)=>{
	console.log("adding Job Function...");
	mysqlConnection.query('SELECT * FROM job_board.job_function_list WHERE Nature=? AND jobFunctionName = ?',[req.body.jobNat,req.body.specFun], (err,result)=>{
		console.log("result length: "+result.length);
		console.log(req.body.jobNat+" "+mysqlConnection.escape(req.body.specFun));
		if (result.length > 0){
			res.render('index',{result: "Duplicate record inside DB"});
		} else{
			mysqlConnection.query('SELECT NatureID FROM job_board.function_nature WHERE Nature = ?',req.body.jobNat, (err,row)=>{
				var sql = {
					FunctionNatureID: row[0].NatureID,
					JobFunctionName: req.body.specFun
				}
				mysqlConnection.query('INSERT INTO job_function SET ?',sql, (err,result)=>{
					console.log("Insert into job_function successful");
				});
				var Nat = req.body.jobNat, fun = req.body.specFun;
				var listItem = ["<li>Job Nature: "+Nat+"</li>", "<li>Job Function: "+fun+"</li>"];
				res.render('index',{result: `Insert into job_function successful`, listItem: listItem});
			});
		}
	});
});

// ADD the actual Job description
app.post('/api/addJob',(req,res)=>{
	console.log("adding Job...");
	var sqlString = {
		JobID: req.body.JobID,
		Date: req.body.date,
		JobTitleID: req.body.jobTitle,
		Requirement: req.body.Requirement,
		YearOfExp: req.body.ExpYrs,
		Vacancies: req.body.vac
	};
	//console.log("Number of job function: "+Object.keys(req.body.jobFun).length);
	queryJob('SELECT * FROM job_board.job_description WHERE JobID = ?;SELECT Count(*) AS \'count\' FROM job_board.job WHERE JobID = ?',[sqlString.JobID,sqlString.JobID], (err,result)=>{
		if(result[1][0].count==0){
			queryJob('SELECT * FROM job_board.employer WHERE employer = ?',req.body.Employer, (err, result)=>{
				if(err) console.log(err);
				if(result.length==0){
					queryJob('INSERT INTO job_board.employer(employer) VALUES (?)', req.body.Employer, (err,result)=>{
						if(err) 
							console.log(err);
					});
				}
				queryJob('SELECT * FROM job_board.employer WHERE employer = ?',req.body.Employer, (err, result)=>{
					sqlString.EmployerID=result[0].EmployerID;
					queryJob('INSERT INTO job_board.job_description SET ?', sqlString, (err, result)=>{
						if(err) 
							console.log(err);
						else {
							for (var i = Object.keys(req.body.jobFun).length - 1; i >= 0; i--) {
								var tempInsert = {
									JobID: sqlString.JobID,
									JobFunctionID: req.body.jobFun[i]
								}
								queryJob('INSERT INTO job_and_job_function SET ?',tempInsert,(err,result)=>{
										if (err) {console.log(err);}
									});
							}
							sqlString.JobID = `<li>JobID: ${sqlString.JobID}</li>`;
							sqlString.Date = `<li>Date: ${sqlString.Date}</li>`;
							sqlString.JobTitleID = `<li>Job Title ID:${sqlString.JobTitleID}</li>`;
							sqlString.Requirement = `<li>Requirement: ${sqlString.Requirement}</li>`;
							sqlString.YearOfExp = `<li>Experience years: ${sqlString.YearOfExp}</li>`;
							sqlString.Vacancies = `<li>Vacancies: ${sqlString.Vacancies}</li>`;
							sqlString.EmployerID = `<li>EmployerID: ${sqlString.EmployerID}</li>`;
							res.render('index',{result: `Insert into job_description successful`, listItem: sqlString});
						}
					});
				});
			});
		} else {
			res.render('index',{result: `Duplicate JobID.`, listItem: [req.body.JobID]});
		}
		//res.render('index',{result: `something wrong with the query`, listItem: ""});
	});
});

// EDit job
app.post('/api/edit',(req, res)=>{
	console.log("Editing job");
	var job_des = {
		Date: req.body.date,
		Requirement: req.body.Requirement,
		YearOfExp: req.body.ExpYrs,
		Vacancies: req.body.vac,
		EmployerID: req.body.employer,
		JobTitleID: req.body.jobTitle
	};
	var jobFunArr = []
	for(var i=0; i<req.body.jobFun.length; ++i){
		jobFunArr.push([req.body.JobID, req.body.jobFun[i]]);
	}
	console.log(jobFunArr);
	var updateSQL = `UPDATE job_board.job_description SET ? WHERE JobID = ?;`
	queryJob(updateSQL, [job_des, req.body.JobID], (error,results)=>{
		if(error)
			console.log(error);
		else{
			queryJob('DELETE FROM job_board.job_and_job_function WHERE JobID= ?;INSERT INTO job_board.job_and_job_function (JobID,JobFunctionID) VALUES ?',[req.body.JobID, jobFunArr],(err, results)=>{
				if(err)
					return console.log(err);
				job_des.Date = `<li>Date: ${job_des.Date}</li>`;
				job_des.JobTitleID = `<li>Job Title ID:${job_des.JobTitleID}</li>`;
				job_des.Requirement = `<li>Requirement: ${job_des.Requirement}</li>`;
				job_des.YearOfExp = `<li>Experience years: ${job_des.YearOfExp}</li>`;
				job_des.Vacancies = `<li>Vacancies: ${job_des.Vacancies}</li>`;
				job_des.EmployerID = `<li>EmployerID: ${job_des.EmployerID}</li>`;
				res.render('index',{result: `Job No of "${req.body.JobID}" Updated`,listItem: job_des});
			})
		}
	});
});

// DELETE record
app.post('/api/deleteByID',(req,res)=>{
	//res.end();
	mysqlConnection.beginTransaction((err)=>{
		if(err){throw err;}
		console.log("deleting job ...");
		var jobID = mysqlConnection.escape(req.body.id);
		console.log(jobID);
		var deleteSQL = `DELETE FROM job_and_job_function WHERE JobID = ${jobID};DELETE FROM job_description WHERE JobID = ${jobID};`
		
		queryJob(deleteSQL,(err, result)=>{
			if(err){
				console.log(err);
				return mysqlConnection.rollback(()=>{
					throw err;
				});
			}
			else{
				mysqlConnection.commit((err)=>{
					if(err)
						return mysqlConnection.rollback(()=>{
							throw err;
						});
					console.log(`Delete of Job ID ${jobID} complete`);
					res.render('index',{result: `Delete of JobID ${jobID} complete`, listItem: null})
				});
			}
		});
	});
});
/* ----------------------------Routing page function-------------------------------*/
// index page
app.get('/', function (req, res) {
	console.log("Got a GET request for the homepage");
	res.render('index',{result: "", listItem: null});
});

// Read page
app.get('/read', function (req, res){
	mysqlConnection.query('SELECT * FROM job_board.job  WHERE Vacancies >0 ORDER BY JobID;SELECT * FROM job_board.job_jobnature_jobfunction', (err, results)=>{
		if (err) {
			console.log(err);
		} else{
			var job = results[0];
			var job_function = results[1];
			res.render('Read',{job: job, fun: job_function});
		}	
	});
});

// Edit page
app.get('/editByID', (req, res)=>{
	var data;
	var infoSQL = 'SELECT * FROM job_board.job_function_list ORDER BY Nature; SELECT * FROM job_board.job_title; SELECT * FROM job_board.employer';
	queryJob('SELECT * FROM job_board.job WHERE JobID= ?;', req.query.id, (err, result)=>{
		data=result;
		queryJob(infoSQL, null, (err, result)=>{
			//res.end();
			res.render('edit', {Jtitle: result[1], orig: data, JobFun: result[0], employers: result[2]});
		})
	});
});

// Inserting page
app.get('/add', function (req, res) {
	console.log("Got a GET request for the ADD");
	mysqlConnection.query('SELECT * FROM job_board.job_function_list ORDER BY Nature; SELECT * FROM job_Board.function_nature; SELECT * FROM job_board.job_title', (err, result)=>{
		if(err)
			console.log(err);
		var data = result[0];
		res.render('add', {data: data, nature: result[1], Jtitle: result[2]});
   	});
});

// RESTful api allow user to query a joblist
app.get('/JobList', (req,res)=>{
	mysqlConnection.query('SELECT * FROM job_board.job  WHERE Vacancies >0 ORDER BY JobID;SELECT * FROM job_board.job_jobnature_jobfunction', (err, results)=>{
		if (err) {
			console.log(err);
		} else{
			var job = results[0];
			var job_function = results[1];
			var jsonObj = {
				"job": "undefined"
			};
			var jsonJobFun = [];
			jsonObj["job"]={};
			var noOfObj = 0;
			for(var i = 0; i<job.length; ++i){
				var job_des = {
					"JobNumber": job[i].JobID,
					"JobTitle": job[i].JobTitle,
					"Employer": job[i].employer,
					"Date": job[i].date,
					"YearOfExperience": job[i].YearOfExp,
					"Vacancies": job[i].Vacancies,
					"Requirement": job[i].Requirement
				};
				noOfObj = 0;
				jsonJobFun = {};
				// jsonJobFun["Job Function"] = {};
				jsonObj['job'][job[i].JobID]=job_des;
				for(var j =0; j<job_function.length; ++j){
					if(job_function[j].JobID == job[i].JobID)
						jsonJobFun[noOfObj++]=job_function[j];
				}
				jsonObj['job'][job[i].JobID]["Job Function"]=jsonJobFun;
			}
			res.end(JSON.stringify(jsonObj));
		}	
	});
})

app.listen(3000,()=>console.log('Express server is running at port no : 3000'));