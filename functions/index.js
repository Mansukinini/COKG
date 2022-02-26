const functions = require("firebase-functions");

var admin = require("firebase-admin");
admin.initializeApp();
// var serviceAccount = require("path/to/serviceAccountKey.json");

// admin.initializeApp({
//   credential: admin.credential.cert(serviceAccount)
// });

// // Create and Deploy Your First Cloud Functions
// // https://firebase.google.com/docs/functions/write-firebase-functions
//
// exports.helloWorld = functions.https.onRequest((request, response) => {
//   functions.logger.info("Hello logs!", {structuredData: true});
//   response.send("Hello from Firebase!");
// });

exports.onCreateFollower = functions.firestore
    .document("/followers/{userId}/userFollowers/{followerId}")
    .onCreate(async(snapshot, context) => {
        console.log("Follower Create", snapshot.data);
        const userId = context.params.userId;
        const followerId = context.params.followerId;

        // 1) Create followed users event ref
        const followedUserRef = admin.firestore()
            .collection('event')
            .doc(userId)
            .collection('userEvents');

        // 2) Create following user's timeline ref
        const timelineEventRef = admin.firestore()
            .collection('timeline')
            .doc(followerId)
            .collection('timelineEvents');

        // 3) Get followed users posts
        const querySnapshot = await followedUserRef.get()

        // 4) Add each user event to the following user's timeline
        querySnapshot.forEach(doc => {
            if (doc.exists) {
                const eventId = doc.id;
                const eventData = doc.data();

                timelineEventRef.doc(eventId).set(eventData);
            }
        });
    });

exports.onDeleteFollower = functions.firestore
    .document("/followers/{userId}/userFollowers/{followerId}")
    .onDelete(async(snapshot, context) => {
        const userId = context.params.userId;
        const followerId = context.params.followerId;

        const timelineEventRef = admin.firestore()
            .collection('timeline')
            .doc(followerId)
            .collection('timelineEvents')
            .where("createdBy", "==", userId);

        const querySnapshot = await timelineEventRef.get();

        querySnapshot.forEach(doc => {
            if (doc.exists) {
                doc.ref.delete();
            }
        });
    });

exports.onCreatePost = functions.firestore
    .document('/event/{userId}/userEvents/{eventId}')
    .onCreate(async (snapshot, context) => {
        const eventCreatedBy = snapshot.data();
        const userId = context.params.userId;
        const eventId = context.params.eventId;

        // 1) Get all the followers of the user who made the post
        const userFollowers = admin.firestore()
            .collection('followers')
            .doc(userId)
            .collection('userFollowers');

            const querySnapshot = await userFollowers.get();

            // 2) Add new post to each follower's timeline
            querySnapshot.forEach(doc => {
                const followerId = doc.id; 

                admin.firestore()
                    .collection('timeline')
                    .doc(followerId)
                    .collection('timelineEvents')
                    .doc(eventId)
                    .set(eventCreatedBy);
            });
    });

exports.onUpdateEvent = functions.firestore
    .document('/event/{userId}/userEvents/{eventId}')
    .onUpdate(async (change, context) => {
        const eventUpdated = change.after.data();

        const userId = context.params.userId;
        const eventId = context.params.eventId;

        const userFollowers = admin.firestore()
            .collection('followers')
            .doc(userId)
            .collection('userFollowers');

        const querySnapshot = await userFollowers.get();

        // 2) update each post in each folloers timeline
        querySnapshot.forEach(doc => {
            const followerId = doc.id; 

            admin.firestore()
                .collection('timeline')
                .doc(followerId)
                .collection('timelineEvents')
                .doc(eventId)
                .get().then(doc => {
                    if  (doc.exists) {
                        doc.ref.update(eventUpdated);
                    }
                });
        });
    });

exports.onDeleteEvent = functions.firestore
    .document('/event/{userId}/userEvents/{eventId}')
    .onDelete(async (snapshot, context) => {

        const userId = context.params.userId;
        const eventId = context.params.eventId;

        const userFollowers = admin.firestore()
            .collection('followers')
            .doc(userId)
            .collection('userFollowers');

        const querySnapshot = await userFollowers.get();

        // 2) delete each post in each followers timeline
        querySnapshot.forEach(doc => {
            const followerId = doc.id; 

            admin.firestore()
                .collection('timeline')
                .doc(followerId)
                .collection('timelineEvents')
                .doc(eventId)
                .get().then(doc => {
                    if  (doc.exists) {
                        doc.ref.delete();
                    }
                });
        });
    });
