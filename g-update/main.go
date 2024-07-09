package main

import (
	"errors"
	"fmt"
	"log"
	"os"
	"os/exec"

	"github.com/go-git/go-git/v5"
)

// retruns a list of dir
func IsDirectory(path string, debug ...bool) ([]string, error) {
	listDir := []string{}
	fi, err := os.ReadDir(path)
	if err != nil {
		return listDir, err
	}
	for _, v := range fi {
		if len(debug) > 0 {
			fmt.Println(v.IsDir(), v.Name())
		}
		if v.IsDir() {
			listDir = append(listDir, v.Name())
		}
	}
	return listDir, err
}

func pullLatest(path string, debug ...bool) error {

	os.Chdir(path)
	if len(debug) > 0 {
		cmd := exec.Command("ls", "-al")
		stdout, err := cmd.Output()

		if err != nil {
			return err
		}
		log.Print(string(stdout), "\n", path)
	}

	log.Print(fmt.Sprintf("opening the git repo %s", path))
	r, err := git.PlainOpen(".")
	if err != nil {
		return err
	}
	// Get the working directory for the repository
	w, err := r.Worktree()
	if err != nil {
		return err
	}
	// Pull the latest changes from the origin remote and merge into the current branch
	log.Print("git pull origin")
	err = w.Pull(&git.PullOptions{})
	if errors.Is(err, git.NoErrAlreadyUpToDate) {
		log.Print(err.Error())
	} else {
		return err
	}
	return nil
}

func main() {
	listDir, err := IsDirectory(".")
	if err != nil {
		log.Fatal(err)
	}
	fmt.Println(listDir)
	for _, v := range listDir {
		path := fmt.Sprintf("./%s", v)
		err := pullLatest(path)
		if err != nil {
			log.Fatal(err)
		}
	}
}
