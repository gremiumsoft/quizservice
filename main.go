package main

import (
	"context"
	"fmt"
	"log"
	"net"

	quiz "github.com/gremiumsoft/api-models-go/quizservice"
	"google.golang.org/grpc"
)

const port = 8001

func main() {
	lis, err := net.Listen("tcp", fmt.Sprintf(":%d", port))
	if err != nil {
		log.Fatalf("failed to listen: %v", err)
	}
	log.Println("starting quizservice")
	grpcServer := grpc.NewServer()

	quiz.RegisterQuizServiceServer(grpcServer, quizServiceServer{})

	if err := grpcServer.Serve(lis); err != nil {
		log.Fatal(err)
	}
}

type quizServiceServer struct {
}

func (quizServiceServer) GetQuestions(ctx context.Context, req *quiz.QuizRequest) (*quiz.QuestionQuizList, error) {
	questionList := &quiz.QuestionQuizList{}
	// TODO(JN): Hardcode the data for now as we don't have any database
	questionList.QuizQuestion = []*quiz.QuizQuestion{
		{
			Id: "kqtg5h5thg45",
			Question: "Pick 1",
			Answers: []string{"One", "Two", "Three"},
			CorrectAnswerIdx: 0,
		},
		{
			Id: "3hg35gk3g3h6",
			Question: "How many days is in a year",
			Answers: []string{"649", "356", "364.25", "9"},
			CorrectAnswerIdx: 2,
		},
	}

	return questionList, nil
}
