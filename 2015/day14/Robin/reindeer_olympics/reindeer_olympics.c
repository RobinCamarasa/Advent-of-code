#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "reindeer_olympics.h"


void parse(deer_t *deers, char *path){
    FILE *file;
    char *line=NULL, *token=NULL;
    size_t n;
    ssize_t n_read;
    file = fopen(path, "r");
    while((n_read = getline(&line, &n, file)) != -1){
        token = strtok(line, "\n");
        token = strtok(token, " ");
        for (int i=0; i<3; i++)
            token = strtok(NULL, " ");
        deers->speed = atoi(token);
        for (int i=0; i<3; i++)
            token = strtok(NULL, " ");
        deers->time = atoi(token);
        for (int i=0; i<7; i++)
            token = strtok(NULL, " ");
        deers->rest_time = atoi(token);
        deers->next = malloc(sizeof(deer_t));
        deers = deers->next;
    }
    deers->next = NULL;
    fclose(file);
}

int get_max_distance(deer_t *deers, int end_time){
    int time, max_distance=-1, distance=0;
    while (deers->next != NULL){
        time = 0;
        distance = 0;
        while (end_time - time > 0){
            if (end_time - time < deers->time){
                distance += deers->speed * (end_time - time);
                time = end_time;
            } else {
                distance += deers->speed * deers->time;
                time += deers->rest_time + deers->time;
            }
        }
        if (distance > max_distance){
            max_distance = distance;
        }
        deers=deers->next;
    }
    return max_distance;
}


int get_max_points(deer_t *deers, int end_time){
    // Declare variables
    deer_t *working_deers;
    int n_deers=0, *points;
    position_t **positions, *working_position, *tmp_position;
    int i, time, distance=0;
    int min_time, max_distance, delta_time, max_points=0;

    // Count number of deers
    working_deers = deers;
    while (working_deers->next != NULL){
        n_deers++;
        working_deers = working_deers->next;
    }

    // Initialize table of list of positions and the table of points
    points = malloc(n_deers * sizeof(int));
    positions = malloc(n_deers * sizeof(position_t*));
    working_deers = deers;
    for (i=0; i < n_deers; i++){
        points[i] = 0;
        positions[i] = malloc(sizeof(position_t));
    }
    i = 0;

    // Initialize the positions
    while (working_deers->next != NULL){
        working_position = positions[i];
        time = 0;
        distance = 0;
        while (end_time - time > 0){
            for (int t=0; t<working_deers->time; t++){
                time++;
                distance += working_deers->speed;
                working_position->time = time;
                working_position->distance = distance;
                working_position->next = malloc(sizeof(position_t));
                working_position = working_position->next;
            }
            time += working_deers->rest_time;
            working_position->time = time;
            working_position->distance = distance;
            working_position->next = malloc(sizeof(position_t));
            working_position = working_position->next;
        }
        i++;
        working_deers=working_deers->next;
    }

    // Compute the points
    time = 0;
    while (end_time - time > 0){
        max_distance = -1;
        min_time = end_time;

        // Update reindeers positions
        for (int i=0; i<n_deers; i++){
            while(positions[i]->time <= time){
                working_position = positions[i];
                tmp_position = positions[i];
                positions[i] = positions[i]->next;
                free(tmp_position);
            }
            if (positions[i]->time < min_time)
                min_time = positions[i]->time;
            if (positions[i]->distance > max_distance)
                max_distance = positions[i]->distance;
        }

        // Get the delta time where the reindeer that runne the max distance
        // is first
        if (min_time > end_time){
            delta_time = end_time - time;
        } else {
            delta_time = min_time - time;
        }
        time = min_time;

        // Update points
        for (int i=0; i<n_deers; i++){
            if (positions[i]->distance == max_distance)
                points[i] += delta_time;
        }
    }

    // Get maximum of points
    for (int i=0; i<n_deers; i++){
        if (points[i] >= max_points){
            max_points = points[i];
        }
    }

    // Free structures
    free(points);
    for (int i=0; i<n_deers; i++){
        while(positions[i]->next != NULL){
            working_position = positions[i];
            tmp_position = positions[i];
            positions[i] = positions[i]->next;
            free(tmp_position);
        }
    }
    free(positions);

    // Return the max of points
    return max_points;
}


void free_deers(deer_t *deers){
    // Free the deer structure
    if (deers != NULL){
        free_deers(deers->next);
        free(deers);
    }
}
