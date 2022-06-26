const express = require('express')
// const expressLayouts = require('express-ejs-layouts')
// const bodyParser = require('body-parser');
const mysql = require('mysql');
const path = require("path")
require('dotenv').config()
var multer  = require('multer')
const fetch = require('isomorphic-fetch')
const sessions = require('express-session');
const app = express()
const port = 3000

//normal mysql  connect
const conn=mysql.createConnection({
    host:'localhost',
    user:'root',
    password:'',
    database:'ors'
});

conn.connect(function(error){
    if(!!error) console.log(error);
    else console.log('Database Connected!');
}); 

// connect using ORM sequelize
const { Sequelize , QueryTypes } = require('sequelize');

const sequelize = new Sequelize('ors', 'root', '', {
    host: 'localhost',
    dialect: 'mysql'
  });

app.use(express.static('public'));

// var app = express()
// app.set('trust proxy', 1) // trust first proxy
// app.use(session({
//   secret: 'keyboard cat',
//   resave: false,
//   saveUninitialized: true,
//   cookie: { secure: true,  maxAge: 60000 }
// }))

const oneDay = 1000 * 60 * 60 * 24;
app.use(sessions({
  secret: "thisismysecrctekeyfhrgfgrfrty84fwir767",
  saveUninitialized:true,
  cookie: { maxAge: oneDay },
  resave: false
}));

//app.use(expressLayouts)

// Set View's
app.set('views', './public/views');
app.set('view engine', 'ejs');
app.use(express.json());
app.use(express.urlencoded({
  extended: false
}));

//uploading
let  nameFile;
const storage = multer.diskStorage({
    destination:`${__dirname}/public/img`,
    filename:(req,file,cb) => {
        const fileName = `${Date.now()}${path.extname(file.originalname)}`;
        nameFile = fileName;
        cb(null,fileName)
    }
})

const upload = multer({ storage }).single('image')

//customer
app.get('', async (req, res) => {
    const room_size = await sequelize.query("SELECT * FROM room_size ", { type: QueryTypes.SELECT });
    res.render('index', { data : room_size })
})

//room

  //async room
  app.get('/rooms', async (req, res) => {
      try {
          
        const room_size = await sequelize.query("select *,(SELECT count(*) FROM  rooms  WHERE rooms.room_type_id = room_size.room_type_id) AS COUNT from room_size", { type: QueryTypes.SELECT });
        //res.json(room_size); 
         console.log(room_size[0],"59")
        res.render('rooms',{data : room_size});
      } catch (err) {
          console.log(err,"62")
      }

  })

  app.post('/reserve/create', async (req, res) => {
    try {
       
     const insert = await sequelize.query(`insert into customers (firstname,middlename,lastname,address,phone_num) values ("${req.body.fn}","${req.body.mn}","${req.body.ln}","${req.body.address}","${req.body.phone_num}")`, { type: QueryTypes.INSERT })
      //res.json(room_size); 
      //console.log(req.body,"124")
      if (insert[1] =! 0) {
        let date_in = new Date(req.body.check_in);
        //let check_in = ((date_in.getMonth() > 8) ? (date_in.getMonth() + 1) : ('0' + (date_in.getMonth() + 1))) + '-' + ((date_in.getDate() > 9) ? date_in.getDate() : ('0' + date_in.getDate())) + '-' + date_in.getFullYear(); 
        let check_in =  date_in.getFullYear() +'-'+ ((date_in.getMonth() > 8) ? (date_in.getMonth() + 1) : ('0' + (date_in.getMonth() + 1))) + '-' + ((date_in.getDate() > 9) ? date_in.getDate() : ('0' + date_in.getDate())); 
        
        let date_out = new Date(req.body.check_out);
        //let check_out =  date_in.getFullYear() +'-'+ ((date_in.getMonth() > 8) ? (date_in.getMonth() + 1) : ('0' + (date_in.getMonth() + 1))) + '-' + ((date_in.getDate() > 9) ? date_in.getDate() : ('0' + date_in.getDate())); 
        let check_out =  date_out.getFullYear() +'-'+ ((date_out.getMonth() > 8) ? (date_out.getMonth() + 1) : ('0' + (date_out.getMonth() + 1))) + '-' + ((date_out.getDate() > 9) ? date_out.getDate() : ('0' + date_out.getDate())); 
        
        
        console.log(check_in)
        console.log(check_out)

        const insert2 = await sequelize.query(`insert into reservations (customer_id,room_type,room_qty,check_in_date,check_out_date,status) values (${insert[0]},${req.body.room_type_id},${req.body.room_qty},"${check_in}","${check_out}","Pending")`, { type: QueryTypes.INSERT })
            if (insert[2] =! 0) {
                
                res.send({success : true});
                console.log(insert2)
            }else{

                console.log(insert)
            }
          res.send({success : true});

        } else {
        
    //     res.send({success : insert});
        console.log(insert)
        }

     //res.render('rooms',{data : room_size});
    } catch (err) {
        console.log(err,"98")
    }

})

//status
app.get('/status', async (req, res) => {
    try {
        
      const select = await sequelize.query(`SELECT * , DATE_FORMAT(created_at,'%d/%m/%Y %H:%i') as date_posted FROM reservation_list`, { type: QueryTypes.SELECT })
       res.render('status', {data : select});
    //   console.log(select)

    } catch (err) {
        console.log(err)
    }

})

//===============================================================================================


// admin
app.get('/login', (req, res) => {
    res.render('login', {  })
})
app.get('/logout', (req, res) => {
    req.session.destroy();
    res.render('login', {  })
})

// admin
app.post('/admin/auth', async (req, res) => {
//    console.log(req.body);


   if (req.body.user == "admin" && req.body.pass == "admin" && req.body['g-recaptcha-response'] != '') {
        console.log(req.body.user);
        console.log(req.body.pass);
        console.log(req.body['g-recaptcha-response']);

        const secretKey = '6Lftcn0gAAAAAEGmj7Q01JATd2AlVQ11qybd27-G'
        const url = `https://www.google.com/recaptcha/api/siteverify?secret=${secretKey}&response=${req.body['g-recaptcha-response']}`
      
        fetch(url, {
          method: 'post',
        })
          .then((response) => response.json())
          .then((google_response) => {
            if (google_response.success == true) {

                req.session.user = "power";

                console.log("true goolgle responnse");
                console.log(req.session.user);
                
                return res.send({ response: true  })
            } else {
                console.log("false goolgle responnse");
              return res.send({ response: false })
            }
          })
          .catch((error) => {
            return res.json({ error })
          })

        //   console.log(req.session.user);
    
   }else{
    return res.send({ response: false })
   }
   
   
//   return res.redirect('/admin/dashboard')
})  


//dashboard
app.get('/admin/dashboard',async (req, res) => {

    console.log(req.session.user);  
    if (req.session.user) {
        let q1 = `SELECT count(*) as rooms FROM rooms`;
        const s1 = await sequelize.query(q1, { type: QueryTypes.SELECT })
    
        let q2 = `SELECT count(*) as customers  FROM customers`;
        const s2 = await sequelize.query(q2, { type: QueryTypes.SELECT })
    
        let q3 = `SELECT count(*) as reservations  FROM reservations`;
        const s3 = await sequelize.query(q3, { type: QueryTypes.SELECT })
    
        let q4 = `SELECT count(*) as check_in  FROM check_in`;
        const s4 = await sequelize.query(q4, { type: QueryTypes.SELECT })
    
        res.render('admin/index', {s1,s2,s3,s4  })
        
    }else{
        res.send("Login First")
    }

})

//reservation

app.get('/admin/reservation', async (req, res) => {

    if (req.session.user) {
        let q = `SELECT * FROM vw_reservation`;
       const select = await sequelize.query(q, { type: QueryTypes.SELECT })
       console.log(select)
       res.render('admin/reservation', { data:select})
    }else{
        res.send("Login First")
    }

})  

//checked in
app.get('/admin/checked-in', async (req, res) => {
    try {

        if (req.session.user) {
        let q = `SELECT *, DATE_FORMAT(date_approved,'%d/%m/%Y %H:%i') as approved FROM check_in_list`;
        const select = await sequelize.query(q, { type: QueryTypes.SELECT })
        console.log(select)
        res.render('admin/checked_in', {data:select  })
        }else{
            res.send("Login First")
        }

    

    } catch (error) {
        console.log(error)
    }
})  

//rooms size
app.get('/admin/room-size', (req, res) => {
  //  res.render('admin/room_size', {  })

  if (req.session.user) {
      conn.query('SELECT * FROM room_size  ',function(err,rows)     {
   
          if(err) {
              console.log(err)
              // render to views/books/index.ejs
              //res.render('/admin/room-size',{data:''});   
          } else {
              // render to views/books/index.ejs
              console.log(rows)
              res.render('admin/room_size',{data:rows});
          }
  
      });
  }else{
    res.send("Login First")
}
        
}
)  

app.get("/admin/room-size-update/:type",async (req, res) => {
    try {
        //if (typeof req.params.type == "number") {
            
            // if (req.session.user = 1) {
                    
            // }else{
            //     res.send("Login First")
            // }
            
            var id = req.params.type;
            console.log(typeof req.params.type,"183")
            console.log(req.params.type,"183")
            // console.log(req.params.type,"1")
            const a = await sequelize.query(`SELECT *  FROM room_size where room_type_id = ${id}`, { type: QueryTypes.SELECT })
        
            res.render("admin/room_size_update",{data : a});
        //}
   
    } catch (error) {
        console.log(error,"184")
    }
});

app.post("/admin/room-size-delete",upload,async (req, res) => {

    try {
        let q = `DELETE FROM room_size WHERE room_type_id  =${req.body.id}`;
        const [result,meta] = await sequelize.query(q, { type: QueryTypes.DELETE })

        if (meta == 1) {
            res.send({success : true})
        } else {
            res.send({success : false})
        }

    } catch (error) {
        console.log(error,"213")
    }
});





app.post('/room-size/create', upload, function (req, res) {
    

    if(res){
        var form_data = {
            pic: nameFile,
            room_size_name: req.body.name,
            rate: req.body.rate,
            description :req.body.desc
        }
        
        // insert query
        conn.query('INSERT INTO room_size SET ?', form_data, function(err, result) {
            //if(err) throw err
            if (err) {
                console.log(err)
            } else {                
               console.log(result)
               res.send({success : true})
            }
        })
    }
 });

 //room
 app.get('/admin/room', (req, res) => {
      
    
if (req.session.user) {
        
    let data_select = []; 
    let data_table = []; 

   conn.query('SELECT * FROM room_size ORDER BY room_type_id DESC  ',function(err,rows)     {

       if(err) {
           console.log(err)
           // render to views/books/index.ejs
           //res.render('/admin/room-size',{data:''});   
       } else {
           // render to views/books/index.ejs
           // res.render('admin/room',{data:rows});
           data_select.push(rows);
       //    console.log(data_select[0])
         conn.query('SELECT room_id,room_size_name,description,rate,is_available FROM rooms r INNER JOIN  room_size  rs on r.room_type_id = rs.room_type_id',function(err,rows1)     {

           if(err) {
               console.log(err)
               // render to views/books/index.ejs
               //res.render('/admin/room-size',{data:''});   
           } else {
               // render to views/books/index.ejs
                data_table.push(rows1);
                //console.log(data_table[0])

                res.render('admin/room',{ data_select:data_select[0] , data_table:data_table[0] });
           }
          // data.table  = rows;
       });
       }

   });
}else{
    res.send("Login First")
}

    // conn.query('SELECT room_id,room_size_name,description,rate,is_available FROM rooms r INNER JOIN  room_size  rs on r.room_type_id = rs.room_type_id',function(err,rows)     {
 
    //     if(err) {
    //         console.log(err)
    //         // render to views/books/index.ejs
    //         //res.render('/admin/room-size',{data:''});   
    //     } else {
    //         // render to views/books/index.ejs
    //          console.log(rows)
    //     }
    //    // data.table  = rows;
    // });
    
   // res.render('admin/room',{data:data});
    //console.log(data);
})

app.post('/room/create', (req, res) => {
    
    if (req) {

        for (let index = 0; index < req.body.room_qty; index++) {
            // const element = array[index];
             // console.log(index+1)  
              
               var form_data = {
                    room_type_id: req.body.room_size
                }
                
                conn.query('INSERT INTO rooms SET ?', form_data, function(err, result) {
                    //if(err) throw err
                    if (err) {
                        console.log(err) 
                    } else {                
                       // console.log(result)
                    }
                })
            }
            res.send({success : true})

      


    } else {
        
    }
})

app.post('/reservation/approve',async (req, res) => {
    try {
        let q = `insert into check_in (customer_id,reservation_id) VALUES (${req.body.customer_id},${req.body.reservation_id})`;
        const [result,meta] = await sequelize.query(q, { type: QueryTypes.INSERT })
        
        let q1 =`update reservations  SET status = "Approved" WHERE reservation_id=${req.body.reservation_id}`;
        const [result1,meta1] = await sequelize.query(q1, { type: QueryTypes.UPDATE })
        
         
        if (meta == 1 && meta1 == 1) {
            res.send({success : true})
        } else {
            res.send({success : false})
        }

    } catch (error) {
        console.log(error,"335")
    }
})

app.get('/assign-room/:room/:check_id',async (req, res) => {

    try {
        let q = `SELECT * FROM rooms where room_type_id = ${req.params.room} and is_available=1`;
        const select = await sequelize.query(q, { type: QueryTypes.SELECT })
        console.log(select)
        res.render("admin/assign_room",{data:select,ch_id:req.params.check_id});
    } catch (error) {
        console.log(error)
    }    
})

app.post('/assign-room/save', async (req, res) => {

    try {

        // let q = `SELECT * FROM rooms where room_type_id = ${req.params.room} and is_available=false`;
        // const select = await sequelize.query(q, { type: QueryTypes.SELECT })
        // console.log(select)
        // res.render("admin/assign_room",{data:select});
        let ch_id = req.body.id;
        let rooms = req.body.rooms;

         let mi =``;
         if (rooms.length > 1) {
             rooms.forEach(e => {
                 mi +=`(${e},${ch_id}),`;
             });
             
         } else {
             mi =`(${req.body.rooms},${ch_id}),`
         }
         console.log(mi)


        let q = `insert into room_assigned (room_id,check_in_id) VALUES ${mi}`;
        const final_q = q.slice(0, -1)
        const [result,meta] = await sequelize.query(final_q, { type: QueryTypes.INSERT })
        console.log(meta)
        
        // let u = `update rooms `;
        // const [result1,meta1] = await sequelize.query(u, { type: QueryTypes.UPDATE })
        if (rooms.length > 1) {
            rooms.forEach(e => {;
                conn.query(`Update rooms set is_available = 0 where room_id = ${e}`,function(err,rows){
                });
            });
            
        } else {
            conn.query(`Update rooms set is_available = 0 where room_id = ${rooms}`,function(err,rows){
            });
        }
        
        let u = `update check_in  SET  is_assigned=1 where check_in_id = ${ch_id}`;
        const [result1,meta1] = await sequelize.query(u, { type: QueryTypes.UPDATE })
        console.log(meta1)

        res.send({success : true})

    } catch (error) {
        console.log(error)
    }    
})

app.get('/admin/check-out/:ch_id',async (req, res) => {

    try {
        let q = `select rs.room_size_name,rs.rate ,SUM(rs.rate) as total FROM room_assigned ra
        inner join check_in ci on ra.check_in_id = ci.check_in_id
        inner join reservations r on ci.reservation_id = r.reservation_id
        inner join room_size rs  on r.room_type = rs.room_type_id
        where ra.check_in_id = ${req.params.ch_id}`;
        const select = await sequelize.query(q, { type: QueryTypes.SELECT })
     
        let q1 = `select count(*) as qty from room_assigned where check_in_id = ${req.params.ch_id}`;
        const total = await sequelize.query(q1, { type: QueryTypes.SELECT })

        let id = req.params.ch_id;

        console.log(select)
        console.log(total)
        res.render("admin/check-out",{select,total,id});
    } catch (error) {
        console.log(error)
    }    
})

app.post('/check-out/save',async (req, res) => {
    try {
        let u = `update check_in  SET  is_paid=1 where check_in_id = ${req.body.id}`;
        const [result1,meta1] = await sequelize.query(u, { type: QueryTypes.UPDATE })
        if (meta1 == 1) {
            res.send({success : true})
        } else {
            
        }
        console.log(meta1)
    } catch (error) {
        console.log(error)
    }
});


// Listen on Port 5000
app.listen(port, () => console.info(`App listening on port ${port}`))